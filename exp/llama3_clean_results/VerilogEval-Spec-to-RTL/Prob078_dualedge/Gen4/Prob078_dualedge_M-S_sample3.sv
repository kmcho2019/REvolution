module TopModule(
    input clk,
    input d,
    output reg q
);

// Capture input 'd' on both edges of the clock 'clk'
always @(posedge clk or negedge clk) begin
    q <= d;
end

endmodule