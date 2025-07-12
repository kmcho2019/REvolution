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

parameter DEFAULT_VAL = 16'hFFFF; // Configurable default value

// Early detection of invalid selection for power optimization
wire valid_sel = (sel < 9);

always @(*) begin
    if (!valid_sel) begin
        out = DEFAULT_VAL; // Early exit for invalid cases (9-15)
    end else begin
        // Simple, optimized case statement
        case (sel)
            4'd0: out = a;
            4'd1: out = b;
            4'd2: out = c;
            4'd3: out = d;
            4'd4: out = e;
            4'd5: out = f;
            4'd6: out = g;
            4'd7: out = h;
            4'd8: out = i;
            // No default needed due to early exit
        endcase
    end
end

/* Implementation Notes:
   - Early invalid selection detection minimizes power consumption
   - Parameterized default value adds flexibility
   - Single-level case statement optimized by synthesis tools
   - No redundant default case saves area
   - Clean structure maintains readability
*/

endmodule