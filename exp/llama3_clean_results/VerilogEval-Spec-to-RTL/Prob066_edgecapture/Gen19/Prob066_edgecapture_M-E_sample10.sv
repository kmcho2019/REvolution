module TopModule(
    input  clk,
    input  reset,
    input  [31:0] in,
    output reg [31:0] out = 32'd0
);

reg [31:0] prev_in = 32'd0;

always @(posedge clk) begin
    if (reset) begin
        out <= 32'd0;
        prev_in <= 32'd0;
    end else begin
        // Detect falling edges
        reg [31:0] falling_edges = ~in & prev_in;
        
        // Update output bits based on falling edges
        out <= out | falling_edges;
        
        // Update previous state
        prev_in <= in;
    end
end

endmodule