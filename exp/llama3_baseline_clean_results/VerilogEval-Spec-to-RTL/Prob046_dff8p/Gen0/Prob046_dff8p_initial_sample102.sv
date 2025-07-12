module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 8'd52; // 0x34 in decimal is 52
    end else begin
        q <= d;
    end
end

// Invert the clock signal for negative edge detection
wire neg_clk;
assign neg_clk = ~clk;

always @(negedge neg_clk) begin
    // no need for extra code here as the output q has already been updated
    // at the posedge of clk due to our use of the non-inverting and inverting
    // clock above.
end

endmodule