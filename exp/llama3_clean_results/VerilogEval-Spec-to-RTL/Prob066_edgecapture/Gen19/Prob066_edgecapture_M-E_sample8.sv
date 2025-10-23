module TopModule(
    input  clk,
    input  reset,
    input  [31:0] in,
    output reg [31:0] out
);

reg [31:0] prev_in;

always @(posedge clk) begin
    if (reset) begin
        out <= 32'd0;
        prev_in <= 32'd0;
    end else begin
        // Detect transitions and update output
        out <= out | (~in & prev_in);
        
        // Update prev_in at the end of the clock cycle
        prev_in <= in;
    end
end

endmodule