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

// Early detection of invalid selection
wire valid_sel = (sel < 9);

// Selection logic using continuous assignment
assign out = !valid_sel ? 16'hFFFF :  // Invalid cases
             (sel == 4'd0) ? a :
             (sel == 4'd1) ? b :
             (sel == 4'd2) ? c :
             (sel == 4'd3) ? d :
             (sel == 4'd4) ? e :
             (sel == 4'd5) ? f :
             (sel == 4'd6) ? g :
             (sel == 4'd7) ? h :
             (sel == 4'd8) ? i :
             16'hFFFF;  // Redundant default for completeness

/* Implementation Notes:
   - Continuous assignment replaces procedural block
   - Same early invalid selection detection
   - Ternary operator implements the same selection logic
   - Output is now a wire instead of reg
   - Maintains all original functionality
*/

endmodule