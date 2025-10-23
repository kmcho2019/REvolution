module TopModule (
    input  [99:0] in,
    output [99:0] out,
    input  clk,
    input  reset
);

reg [99:0] shift_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        shift_reg <= 0;
    end else begin
        shift_reg <= {in[0], shift_reg[99:1]};
    end
end

always @(*) begin
    out <= shift_reg;
end

endmodule