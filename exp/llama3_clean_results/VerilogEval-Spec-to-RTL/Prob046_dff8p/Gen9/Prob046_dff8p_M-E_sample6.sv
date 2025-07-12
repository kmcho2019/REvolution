// TopModule implements an 8-bit register using a shift register with synchronous reset
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg;

always @(negedge clk) begin
    if (reset) begin
        q_reg <= 8'h34; // Load reset value
    end else begin
        q_reg <= {d[6:0], d[7]}; // Shift in input data
    end
end

assign q = q_reg;

endmodule