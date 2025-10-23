module TopModule #(
    parameter INPUT_WIDTH = 3,
    parameter OUTPUT_WIDTH = 16
) (
    input  [INPUT_WIDTH-1:0] a,
    output [OUTPUT_WIDTH-1:0] q
);

reg [OUTPUT_WIDTH-1:0] q_reg;

always @(*) begin
    case (a)
        3'b000: q_reg = 16'h1232;
        3'b001: q_reg = 16'haee0;
        3'b010: q_reg = 16'h27d4;
        3'b011: q_reg = 16'h5a0e;
        3'b100: q_reg = 16'h2066;
        3'b101: q_reg = 16'h64ce;
        3'b110: q_reg = 16'hc526;
        3'b111: q_reg = 16'h2f19;
        default: q_reg = 16'hxxxx;
    endcase
end

assign q = q_reg;

endmodule