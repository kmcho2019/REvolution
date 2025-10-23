module TopModule(
    input  clk,
    input  d,
    output reg q
);

reg clk_rising_edge;
reg clk_falling_edge;

// Detect rising and falling edges
always @(posedge clk or negedge clk) begin
    if (!clk) begin
        clk_rising_edge <= 1'b0;
        clk_falling_edge <= 1'b1;
    end else begin
        clk_rising_edge <= 1'b1;
        clk_falling_edge <= 1'b0;
    end
end

// Capture data on both edges
always @(posedge clk_rising_edge or posedge clk_falling_edge) begin
    q <= d;
end

endmodule