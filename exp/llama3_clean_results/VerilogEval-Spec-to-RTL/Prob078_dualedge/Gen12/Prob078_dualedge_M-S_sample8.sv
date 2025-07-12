module TopModule(
    input clk,
    input d,
    output reg q
);

// Update output on both edges of the clock
always @(posedge clk or negedge clk) begin
    q <= d;
end

endmodule