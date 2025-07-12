module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg;

always @(negedge clk) begin
    if(reset) begin
        q_reg <= 8'd52; // Reset value is 0x34 or 52 in decimal
    end else begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule