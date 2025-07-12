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

parameter DEFAULT_VAL = 16'hFFFF;

// Early detection of invalid selection for power optimization
wire valid_sel = (sel < 9);

// Continuous assignment for potential area savings
assign out = (!valid_sel) ? DEFAULT_VAL :
    (sel == 4'd0) ? a :
    (sel == 4'd1) ? b :
    (sel == 4'd2) ? c :
    (sel == 4'd3) ? d :
    (sel == 4'd4) ? e :
    (sel == 4'd5) ? f :
    (sel == 4'd6) ? g :
    (sel == 4'd7) ? h :
    (sel == 4'd8) ? i : DEFAULT_VAL;

/* Implementation Notes:
   - Flattened conditional operator structure for best timing
   - Early invalid sel detection saves power
   - Parameter makes default value configurable
   - Continuous assignment may save area vs registered output
   - No redundant default case
   - Clean structure maintains readability
*/

endmodule