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
    output reg [15:0] out
);

parameter DEFAULT_VAL = 16'hFFFF;

// Early detection of invalid selection for power optimization
wire valid_sel = (sel < 9);

always @(*) begin
    if (!valid_sel) begin
        out = DEFAULT_VAL; // Early exit for invalid cases
    end else begin
        // Hierarchical case structure for better timing
        case (sel[2:0])
            3'd0: out = (sel[3]) ? i : a; // sel=8 vs 0
            3'd1: out = b;
            3'd2: out = c;
            3'd3: out = d;
            3'd4: out = e;
            3'd5: out = f;
            3'd6: out = g;
            3'd7: out = h;
        endcase
    end
end

/* Implementation Notes:
   - Hierarchical case structure reduces critical path
   - Early invalid sel detection saves power
   - Parameter makes default value configurable
   - Clean structure maintains readability
*/

endmodule