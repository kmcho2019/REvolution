module TopModule(
    input  clk,
    input  reset,
    input  [31:0] in,
    output reg [31:0] out = 32'd0
);

reg [31:0] prev_in = 32'd0;

always @(posedge clk) begin
    if (reset) begin
        prev_in <= 32'd0;
        out <= 32'd0;
    end else begin
        // Calculate new out based on current in and previous in
        out <= out | (prev_in & ~in);
        // Update prev_in with current in for next cycle
        prev_in <= in;
    end
end

endmodule