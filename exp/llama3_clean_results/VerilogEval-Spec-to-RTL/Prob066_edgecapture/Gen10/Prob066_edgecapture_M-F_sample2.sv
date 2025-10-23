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
        // Detect transition from 1 to 0 and update out accordingly
        out <= (out | (~in & prev_state)) & {32{1'b1}};
        prev_state <= in;
    end
end

endmodule