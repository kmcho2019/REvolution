module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Internal inverted clock for negative edge triggering
wire neg_clk;
assign neg_clk = ~clk;

// Shift register with parallel load and reset injection
reg [7:0] sr;
assign q = sr;

always @(posedge neg_clk) begin
    if (reset) begin
        // Inject reset value 0x34 (00110100)
        sr <= 8'b00110100;
    end else begin
        // Parallel load of input data
        sr <= d;
    end
end

endmodule