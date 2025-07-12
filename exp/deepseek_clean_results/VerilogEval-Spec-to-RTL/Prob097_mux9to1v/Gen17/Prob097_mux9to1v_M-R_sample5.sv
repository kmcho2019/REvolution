module TopModule (
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0]  sel,
    output [15:0] out
);

// Continuous assignment implementation
assign out = (sel >= 9) ? 16'hFFFF :  // Invalid cases
             (sel == 0) ? a :          // Case 0
             (sel == 1) ? b :          // Case 1
             (sel == 2) ? c :          // Case 2
             (sel == 3) ? d :          // Case 3
             (sel == 4) ? e :          // Case 4
             (sel == 5) ? f :          // Case 5
             (sel == 6) ? g :          // Case 6
             (sel == 7) ? h :          // Case 7
             (sel == 8) ? i :          // Case 8
             16'hFFFF;                 // Redundant default (never reached)

/* Implementation Notes:
   - Pure combinational logic using continuous assignment
   - First checks for invalid selections (sel >= 9)
   - Uses nested ternary operators for the multiplexer
   - Maintains same optimization benefits as original
   - Output is now a wire instead of reg
*/

endmodule