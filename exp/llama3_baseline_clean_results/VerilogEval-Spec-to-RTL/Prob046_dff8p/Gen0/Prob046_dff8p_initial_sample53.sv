module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg = 8'd52; // initialize q_reg with 0x34

always @(negedge clk) begin
    if (reset) begin
        q_reg <= 8'd52; // reset to 0x34
    end else begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule