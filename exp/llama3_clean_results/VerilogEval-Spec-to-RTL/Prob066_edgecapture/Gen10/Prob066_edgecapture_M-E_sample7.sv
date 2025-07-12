module TopModule(
    input  clk,
    input  reset,
    input  [31:0] in,
    output reg [31:0] out
);

reg [31:0] prev_in;
reg [31:0] transition_detected;

always @(posedge clk) begin
    if (reset) begin
        out <= 32'd0;
        transition_detected <= 32'd0;
        prev_in <= 32'd0;
    end else begin
        transition_detected <= transition_detected | (~in & prev_in);
        out <= transition_detected;
        prev_in <= in;
    end
end

endmodule