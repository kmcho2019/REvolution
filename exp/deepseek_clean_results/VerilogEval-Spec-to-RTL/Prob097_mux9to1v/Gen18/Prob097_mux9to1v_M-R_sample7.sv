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

// Early detection of invalid selection remains for power optimization
wire valid_sel = (sel < 9);

// Combine selection and default assignment in one expression
assign out = valid_sel ? 
             (sel == 4'd0 ? a :
              sel == 4'd1 ? b :
              sel == 4'd2 ? c :
              sel == 4'd3 ? d :
              sel == 4'd4 ? e :
              sel == 4'd5 ? f :
              sel == 4'd6 ? g :
              sel == 4'd7 ? h :
              i) : 16'hFFFF;

/* Implementation Notes:
   - Uses continuous assignment for combinational logic
   - Maintains early invalid selection detection
   - Same functionality as original but with wire output
   - More compact representation while preserving readability
   - Potentially better for synthesis as it's pure combinational
*/

endmodule