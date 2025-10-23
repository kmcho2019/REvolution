module TopModule(
    input  clk,
    input  reset,
    input  [31:0] in,
    output reg [31:0] out
);

reg [31:0] prev_state;

always @(posedge clk) begin
    if (reset) begin
        out <= 32'd0;
        prev_state <= 32'd0;
    end else begin
        // Update prev_state for next cycle
        prev_state <= in;
        
        // Set bits in out where transition from 1 to 0 is detected
        out <= out | (~in & prev_state);
    end
end

endmodule