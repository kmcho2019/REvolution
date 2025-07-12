module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg;

always @(posedge clk) begin
    reg prev_clk;
    prev_clk = clk;
    #1;
    if (reset) begin
        q_reg <= 8'd52;  // '0x34' in decimal is 52
    end else begin
        q_reg <= d;
    end
    if (prev_clk == 1'b1 && clk == 1'b0) begin
        // do nothing on falling edge in this implementation
        // but you can add any other logic here if needed
    end
end

assign q = q_reg;

endmodule