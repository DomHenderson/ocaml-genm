################################################################################
#                                                                              #
#                                  OCaml                                       #
#                                                                              #
#                  Nandor Licker, University of Cambridge                      #
#                                                                              #
#    Copyright 2018--     Nandor Licker                                        #
#                                                                              #
#    All rights reserved.  This file is distributed under the terms of         #
#    the GNU Lesser General Public License version 2.1, with the               #
#    special exception on linking described in the file LICENSE.               #
#                                                                              #
################################################################################



################################################################################
# caml_collect
################################################################################
  .text
  .globl caml_collect
caml_collect:
  .visibility extern
  .call caml_gc
  .stack 120

  frame.i64   $0, 0
  mov.i64     $1, $rax
  st.8        [$0], $1
  frame.i64   $0, 8
  mov.i64     $1, $rbx
  st.8        [$0], $1
  frame.i64   $0, 16
  mov.i64     $1, $rdi
  st.8        [$0], $1
  frame.i64   $0, 24
  mov.i64     $1, $rsi
  st.8        [$0], $1
  frame.i64   $0, 32
  mov.i64     $1, $rdx
  st.8        [$0], $1
  frame.i64   $0, 40
  mov.i64     $1, $rcx
  st.8        [$0], $1
  frame.i64   $0, 48
  mov.i64     $1,  $r8
  st.8        [$0],$1
  frame.i64   $0, 56
  mov.i64     $1,  $r9
  st.8        [$0],$1
  frame.i64   $0, 64
  mov.i64     $1, $r12
  st.8        [$0], $1
  frame.i64   $0, 72
  mov.i64     $1, $r13
  st.8        [$0], $1
  frame.i64   $0, 80
  mov.i64     $1, $r10
  st.8        [$0], $1
  frame.i64   $0, 88
  mov.i64     $1, $r11
  st.8        [$0], $1
  frame.i64   $0, 96
  mov.i64     $1, $rbp
  st.8        [$0], $1
  frame.i64   $0, 104
  mov.i64     $1, $r14
  st.8        [$0], $1
  frame.i64   $0, 112
  mov.i64     $1, $r15
  st.8        [$0], $1

  mov.i64     $0, caml_gc_regs
  frame.i64   $1, 0
  st.8        [$0], $1

  mov.i64     $2, caml_garbage_collection
  call.c      $2

  frame.i64   $0, 112
  ld.8.i64    $1, [$0]
  set         $r15, $1
  frame.i64   $0, 104
  ld.8.i64    $1, [$0]
  set         $r14, $1
  frame.i64   $0, 96
  ld.8.i64    $1, [$0]
  set         $rbp, $1
  frame.i64   $0, 88
  ld.8.i64    $1, [$0]
  set         $r11, $1
  frame.i64   $0, 80
  ld.8.i64    $1, [$0]
  set         $r10, $1
  frame.i64   $0, 72
  ld.8.i64    $1, [$0]
  set         $r13, $1
  frame.i64   $0, 64
  ld.8.i64    $1, [$0]
  set         $r12, $1
  frame.i64   $0, 56
  ld.8.i64    $1, [$0]
  set         $r9, $1
  frame.i64   $0, 48
  ld.8.i64    $1, [$0]
  set         $r8, $1
  frame.i64   $0, 40
  ld.8.i64    $1, [$0]
  set         $rcx, $1
  frame.i64   $0, 32
  ld.8.i64    $1, [$0]
  set         $rdx, $1
  frame.i64   $0, 24
  ld.8.i64    $1, [$0]
  set         $rsi, $1
  frame.i64   $0, 16
  ld.8.i64    $1, [$0]
  set         $rdi, $1
  frame.i64   $0, 8
  ld.8.i64    $1, [$0]
  set         $rbx, $1
  frame.i64   $0, 0
  ld.8.i64    $1, [$0]
  set         $rax, $1

  ret


################################################################################
# caml_alloc1
################################################################################
  .text
  .globl caml_alloc1
caml_alloc1:
  .call         caml_alloc
  .args         0
.Lalloc1:
  mov.i64       $0, caml_young_ptr
  ld.8.i64      $1, [$0]
  mov.i64       $2, 16
  sub.i64       $3, $1, $2

  mov.i64       $4, caml_young_limit
  ld.8.i64      $5, [$4]

  cmp.ge.i32    $6, $3, $5
  jf            $6, .Lcollect1

  st.8          [$0], $3
  mov.i64       $7, 8
  add.i64       $8, $3, $7
  ret.i64       $8

.Lcollect1:
  mov.i64       $3, $ret_addr
  mov.i64       $4, caml_last_return_address
  st.8          [$4], $3

  mov.i64       $5, $frame_addr
  mov.i64       $6, caml_bottom_of_stack
  st.8          [$6], $5

  mov.i64       $99, caml_collect
  call.caml_gc  $99
  jmp           .Lalloc1

################################################################################
# caml_alloc2
################################################################################
  .text
  .globl caml_alloc2
caml_alloc2:
  .call         caml_alloc
  .args         0
.Lalloc2:
  mov.i64       $0, caml_young_ptr
  ld.8.i64      $1, [$0]
  mov.i64       $2, 24
  sub.i64       $3, $1, $2

  mov.i64       $4, caml_young_limit
  ld.8.i64      $5, [$4]

  cmp.ge.i32    $6, $3, $5
  jf            $6, .Lcollect2

  st.8          [$0], $3
  mov.i64       $7, 8
  add.i64       $8, $3, $7
  ret.i64       $8

.Lcollect2:
  mov.i64       $3, $ret_addr
  mov.i64       $4, caml_last_return_address
  st.8          [$4], $3

  mov.i64       $5, $frame_addr
  mov.i64       $6, caml_bottom_of_stack
  st.8          [$6], $5

  mov.i64       $99, caml_collect
  call.caml_gc  $99
  jmp           .Lalloc2

################################################################################
# caml_alloc3
################################################################################
  .text
  .globl caml_alloc3
caml_alloc3:
  .call         caml_alloc
  .args         0
.Lalloc3:
  mov.i64       $0, caml_young_ptr
  ld.8.i64      $1, [$0]
  mov.i64       $2, 32
  sub.i64       $3, $1, $2

  mov.i64       $4, caml_young_limit
  ld.8.i64      $5, [$4]

  cmp.ge.i32    $6, $3, $5
  jf            $6, .Lcollect3

  st.8          [$0], $3
  mov.i64       $7, 8
  add.i64       $8, $3, $7
  ret.i64       $8

.Lcollect3:
  mov.i64       $3, $ret_addr
  mov.i64       $4, caml_last_return_address
  st.8          [$4], $3

  mov.i64       $5, $frame_addr
  mov.i64       $6, caml_bottom_of_stack
  st.8          [$6], $5

  mov.i64       $99, caml_collect
  call.caml_gc  $99
  jmp           .Lalloc3

################################################################################
# caml_allocN
################################################################################
  .text
  .globl caml_allocN
caml_allocN:
  .call         caml_alloc
  .args         0, i64
.LallocN:
  mov.i64       $0, caml_young_ptr
  ld.8.i64      $1, [$0]
  arg.i64       $2, 0
  sub.i64       $3, $1, $2

  mov.i64       $4, caml_young_limit
  ld.8.i64      $5, [$4]

  cmp.ge.i32    $6, $3, $5
  jf            $6, .LcollectN

  st.8          [$0], $3
  mov.i64       $7, 8
  add.i64       $8, $3, $7
  ret.i64       $8

.LcollectN:
  mov.i64       $3, $ret_addr
  mov.i64       $4, caml_last_return_address
  st.8          [$4], $3

  mov.i64       $5, $frame_addr
  mov.i64       $6, caml_bottom_of_stack
  st.8          [$6], $5

  mov.i64       $99, caml_collect
  call.caml_gc  $99
  jmp           .LallocN

################################################################################
# caml_c_call
################################################################################
  .text
  .globl caml_c_call
caml_c_call:
  .call       caml_ext
  .args       0, i64

  mov.i64     $3, $ret_addr
  mov.i64     $4, caml_last_return_address
  st.8        [$4], $3

  mov.i64     $7, $frame_addr
  mov.i64     $6, caml_bottom_of_stack
  st.8        [$6], $7

  arg.i64     $8, 0
  tcall.i64.c $8

################################################################################
# caml_c_call_i64
################################################################################
  .text
  .globl caml_c_call_i64
caml_c_call_i64:
  .call       caml_ext
  .args       0, i64, i64

  mov.i64     $3, $ret_addr
  mov.i64     $4, caml_last_return_address
  st.8        [$4], $3

  mov.i64     $7, $frame_addr
  mov.i64     $6, caml_bottom_of_stack
  st.8        [$6], $7

  arg.i64     $8, 0
  arg.i64     $9, 1
  tcall.i64.c $8, $9

################################################################################
# caml_c_call_i64_i64
################################################################################
  .text
  .globl caml_c_call_i64_i64
caml_c_call_i64_i64:
  .call       caml_ext
  .args       0, i64, i64, i64

  mov.i64     $3, $ret_addr
  mov.i64     $4, caml_last_return_address
  st.8        [$4], $3

  mov.i64     $7, $frame_addr
  mov.i64     $6, caml_bottom_of_stack
  st.8        [$6], $7

  arg.i64     $10, 0
  arg.i64     $11, 1
  arg.i64     $12, 2
  tcall.i64.c $10, $11, $12

################################################################################
# caml_c_call_i64_i64_i64
################################################################################
  .text
  .globl caml_c_call_i64_i64_i64
caml_c_call_i64_i64_i64:
  .call       caml_ext
  .args       0, i64, i64, i64, i64

  mov.i64     $3, $ret_addr
  mov.i64     $4, caml_last_return_address
  st.8        [$4], $3

  mov.i64     $7, $frame_addr
  mov.i64     $6, caml_bottom_of_stack
  st.8        [$6], $7

  arg.i64     $10, 0
  arg.i64     $11, 1
  arg.i64     $12, 2
  arg.i64     $13, 3
  tcall.i64.c $10, $11, $12, $13

################################################################################
# caml_c_call_i64_i64_i64_i64
################################################################################
  .text
  .globl caml_c_call_i64_i64_i64_i64
caml_c_call_i64_i64_i64_i64:
  .call       caml_ext
  .args       0, i64, i64, i64, i64, i64

  mov.i64     $3, $ret_addr
  mov.i64     $4, caml_last_return_address
  st.8        [$4], $3

  mov.i64     $7, $frame_addr
  mov.i64     $6, caml_bottom_of_stack
  st.8        [$6], $7

  arg.i64     $10, 0
  arg.i64     $11, 1
  arg.i64     $12, 2
  arg.i64     $13, 3
  arg.i64     $14, 4
  tcall.i64.c $10, $11, $12, $13, $14

################################################################################
# caml_c_call_i64_i64_i64_i64_i64
################################################################################
  .text
  .globl caml_c_call_i64_i64_i64_i64_i64
caml_c_call_i64_i64_i64_i64_i64:
  .call       caml_ext
  .args       0, i64, i64, i64, i64, i64, i64

  mov.i64     $3, $ret_addr
  mov.i64     $4, caml_last_return_address
  st.8        [$4], $3

  mov.i64     $7, $frame_addr
  mov.i64     $6, caml_bottom_of_stack
  st.8        [$6], $7

  arg.i64     $10, 0
  arg.i64     $11, 1
  arg.i64     $12, 2
  arg.i64     $13, 3
  arg.i64     $14, 4
  arg.i64     $15, 5
  tcall.i64.c $10, $11, $12, $13, $14, $15

################################################################################
# caml_c_call_i64_i64_i64_i64_i64
################################################################################
  .text
  .globl caml_c_call_i64_i64_i64_i64_i64_i64
caml_c_call_i64_i64_i64_i64_i64_i64:
  .call       caml_ext
  .args       0, i64, i64, i64, i64, i64, i64, i64

  mov.i64     $3, $ret_addr
  mov.i64     $4, caml_last_return_address
  st.8        [$4], $3

  mov.i64     $7, $frame_addr
  mov.i64     $6, caml_bottom_of_stack
  st.8        [$6], $7

  arg.i64     $10, 0
  arg.i64     $11, 1
  arg.i64     $12, 2
  arg.i64     $13, 3
  arg.i64     $14, 4
  arg.i64     $15, 5
  arg.i64     $16, 6
  tcall.i64.c $10, $11, $12, $13, $14, $15, $16

################################################################################
# caml_c_call_i64_i64_i64_i64_i64_i64_i64_i64_i64_i64
################################################################################
  .text
  .globl caml_c_call_i64_i64_i64_i64_i64_i64_i64_i64_i64_i64
caml_c_call_i64_i64_i64_i64_i64_i64_i64_i64_i64_i64:
  .call       caml_ext
  .args       0, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64

  mov.i64     $3, $ret_addr
  mov.i64     $4, caml_last_return_address
  st.8        [$4], $3

  mov.i64     $7, $frame_addr
  mov.i64     $6, caml_bottom_of_stack
  st.8        [$6], $7

  arg.i64     $10, 0
  arg.i64     $11, 1
  arg.i64     $12, 2
  arg.i64     $13, 3
  arg.i64     $14, 4
  arg.i64     $15, 5
  arg.i64     $16, 6
  arg.i64     $17, 7
  arg.i64     $18, 8
  arg.i64     $19, 9
  arg.i64     $20, 10
  tcall.i64.c $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20

################################################################################
# caml_c_call_i64_i64_i64_i64_i64_i64_i64_i64_i64_i64_i64
################################################################################
  .text
  .globl caml_c_call_i64_i64_i64_i64_i64_i64_i64_i64_i64_i64_i64
caml_c_call_i64_i64_i64_i64_i64_i64_i64_i64_i64_i64_i64:
  .call       caml_ext
  .args       0, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64

  mov.i64     $3, $ret_addr
  mov.i64     $4, caml_last_return_address
  st.8        [$4], $3

  mov.i64     $7, $frame_addr
  mov.i64     $6, caml_bottom_of_stack
  st.8        [$6], $7

  arg.i64     $10, 0
  arg.i64     $11, 1
  arg.i64     $12, 2
  arg.i64     $13, 3
  arg.i64     $14, 4
  arg.i64     $15, 5
  arg.i64     $16, 6
  arg.i64     $17, 7
  arg.i64     $18, 8
  arg.i64     $19, 9
  arg.i64     $20, 10
  arg.i64     $21, 11
  tcall.i64.c $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21

################################################################################
# caml_ml_array_bound_error
################################################################################
  .text
  .globl caml_ml_array_bound_error
caml_ml_array_bound_error:
  .call              caml_raise

  mov.i64            $1, caml_c_call
  mov.i64            $2, caml_array_bound_error
  tcall.i64.caml_ext $1, $2

################################################################################
# caml_callback_exn
################################################################################
  .text
  .globl caml_callback_exn
caml_callback_exn:
  .call             c
  .args             0, i64, i64

  arg.i64           $0, 0
  arg.i64           $1, 1
  ld.8.i64          $2, [$0]

  undef.i64         $3
  mov.i64           $4, caml_start_program_impl
  tcall.i64.c       $4, $2, $1, $0, $3, $3

################################################################################
# caml_callback2_exn
################################################################################
  .text
  .globl caml_callback2_exn
caml_callback2_exn:
  .call             c
  .args             0, i64, i64, i64

  arg.i64           $0, 0
  arg.i64           $1, 1
  arg.i64           $2, 2

  undef.i64         $3
  mov.i64           $4, caml_start_program_impl
  mov.i64           $5, caml_apply2
  tcall.i64.c       $4, $5, $1, $2, $0, $3

################################################################################
# caml_callback3_exn
################################################################################
  .text
  .globl caml_callback3_exn
caml_callback3_exn:
  .call             c
  .args             0, i64, i64, i64, i64

  arg.i64           $0, 0
  arg.i64           $1, 1
  arg.i64           $2, 2
  arg.i64           $3, 3

  mov.i64           $4, caml_start_program_impl
  mov.i64           $5, caml_apply3
  tcall.i64.c       $4, $5, $1, $2, $3, $0

################################################################################
# caml_stack_overflow
################################################################################
  .text
  .globl caml_raise_exception
caml_raise_exception:
  .call       c
  .args       0, i64

  # Check if traces are active.
  mov.i64     $0, caml_backtrace_active
  ld.4.i32    $1, [$0]
  mov.i32     $2, 1
  cmp.eq.i32  $3, $1, $2
  jt          $3, .Lactive
.Lthrow:
  # Raise the exception here.
  arg.i64     $10, 0
  mov.i64     $11, caml_exn_val
  st.8        [$11], $10

  # Load the frame.
  mov.i64     $14, caml_exception_pointer
  mov.i64     $15, 8
  ld.8.i64    $16, [$14]
  add.i64     $17, $16, $15
  add.i64     $18, $17, $15

  ld.8.i64    $19, [$16]    # Address.
  ld.8.i64    $20, [$17]    # Stack pointer.
  ld.8.i64    $21, [$18]    # Next frame.

  # Jump.
  set.i64     $rsp, $20
  st.8        [$14], $21
  ji          $19
.Lactive:
  arg.i64     $10, 0

  mov.i64     $11, caml_last_return_address
  ld.8.i64    $12, [$11]
  mov.i64     $13, caml_bottom_of_stack
  ld.8.i64    $14, [$13]
  mov.i64     $15, caml_exception_pointer
  ld.8.i64    $16, [$15]

  mov.i64     $17, caml_stash_backtrace
  call.c      $17, $10, $12, $14, $16

  jmp .Lthrow

################################################################################
# caml_exn_val
################################################################################
  .data
  .globl caml_exn_val
caml_exn_val:
  .quad 0

################################################################################
# caml_start_program
################################################################################
  .text
  .globl caml_start_program
caml_start_program:
  .call             c
  .stack            48
  .args             0
  .noinline
.Lentry:
  # Save global variables.
  frame.i64         $40, 40
  mov.i64           $0, caml_gc_regs
  ld.8.i64          $1, [$0]
  st.8              [$40], $1

  frame.i64         $41, 32
  mov.i64           $2, caml_last_return_address
  ld.8.i64          $3, [$2]
  st.8              [$41], $3

  frame.i64         $42, 24
  mov.i64           $4, caml_bottom_of_stack
  ld.8.i64          $5, [$4]
  st.8              [$42], $5


  # Create an exception frame.
  frame.i64         $51, 0            # Pointer to handler.
  mov.i64           $54, .Lhandler
  st.8              [$51], $54
  frame.i64         $52, 8            # Pointer to stack frame.
  mov.i64           $55, $rsp
  st.8              [$52], $55
  frame.i64         $53, 16           # Pointer to exn chain.
  mov.i64           $6, caml_exception_pointer
  ld.8.u64          $56, [$6]
  st.8              [$53], $56
  st.8              [$6], $51         # Pointer to this structure.

  # Invoke the OCaml program.
  mov.i64           $90, caml_program
  invoke.i64.caml   $55, $90, .Lhandler @caml_root

.Lreturn:
  phi.i64           $300, .Lentry, $55, .Lhandler, $203

  # Restore global variables, popping the handler.
  ld.8.i64          $400, [$53]
  st.8              [$6], $400

  ld.8.i64          $401, [$42]
  st.8              [$4], $401

  ld.8.i64          $402, [$41]
  st.8              [$2], $402

  ld.8.i64          $403, [$40]
  st.8              [$0], $403

  ret.i64           $300

.Lhandler:
  # Exception handler, marks value as exception.
  mov.i64           $200, caml_exn_val
  ld.8.i64          $201, [$200]
  mov.i64           $202, 2
  or.i64            $203, $201, $202
  jmp               .Lreturn

################################################################################
# caml_start_program_impl
################################################################################
caml_start_program_impl:
  .call             c
  .stack            48
  .args             0, i64, i64, i64, i64, i64
.Lentry_impl:
  # Save global variables.
  frame.i64         $40, 40
  mov.i64           $0, caml_gc_regs
  ld.8.i64          $1, [$0]
  st.8              [$40], $1

  frame.i64         $41, 32
  mov.i64           $2, caml_last_return_address
  ld.8.i64          $3, [$2]
  st.8              [$41], $3

  frame.i64         $42, 24
  mov.i64           $4, caml_bottom_of_stack
  ld.8.i64          $5, [$4]
  st.8              [$42], $5


  # Create an exception frame.
  frame.i64         $51, 0            # Pointer to handler.
  mov.i64           $54, .Lhandler_impl
  st.8              [$51], $54
  frame.i64         $52, 8            # Pointer to stack frame.
  mov.i64           $55, $rsp
  st.8              [$52], $55
  frame.i64         $53, 16           # Pointer to exn chain.
  mov.i64           $6, caml_exception_pointer
  ld.8.u64          $56, [$6]
  st.8              [$53], $56
  st.8              [$6], $51         # Pointer to this structure.

  # Invoke the OCaml program.
  arg.i64           $90, 0
  arg.i64           $91, 1
  arg.i64           $92, 2
  arg.i64           $93, 3
  arg.i64           $94, 4
  invoke.i64.caml   $55, $90, $91, $92, $93, $94, .Lhandler_impl @caml_root

.Lreturn_impl:
  phi.i64           $300, .Lentry_impl, $55, .Lhandler_impl, $203

  # Restore global variables, popping the handler.
  ld.8.i64          $400, [$53]
  st.8              [$6], $400

  ld.8.i64          $401, [$42]
  st.8              [$4], $401

  ld.8.i64          $402, [$41]
  st.8              [$2], $402

  ld.8.i64          $403, [$40]
  st.8              [$0], $403

  ret.i64           $300

.Lhandler_impl:
  # Exception handler, marks value as exception.
  mov.i64           $200, caml_exn_val
  ld.8.i64          $201, [$200]
  mov.i64           $202, 2
  or.i64            $203, $201, $202
  jmp               .Lreturn_impl


################################################################################
# caml_stack_overflow
################################################################################
  .text
  .globl caml_stack_overflow
caml_stack_overflow:
  trap

################################################################################
  .data
externs:
  .quad caml_garbage_collection
