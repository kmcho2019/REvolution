module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg;

initial q_reg = 8'd52;  // initialize with 0x34

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 8'd52;  // reset to 0x34
    end else begin
        q_reg <= d;
    end
end

// Use the negative edge of clk
// This can be achieved by using the following always block and checking for the negative edge of the clk signal
// always @(negedge clk) is not synthesizable for all tools, use the posedge and a delayed clk instead.
reg clk_delayed;
always @(posedge clk) begin
    clk_delayed <= ~clk;
end
always @(posedge clk_delayed) begin
    if (reset) begin
        q_reg <= 8'd52;  // reset to 0x34
    end else begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule