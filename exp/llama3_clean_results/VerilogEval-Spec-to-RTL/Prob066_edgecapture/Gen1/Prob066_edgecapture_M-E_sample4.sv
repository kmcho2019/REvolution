module TopModule(
    input               clk,
    input               reset,
    input      [31:0]    in,
    output reg [31:0]    out
);

reg [31:0] prev_in;
reg [31:0] internal_out;

always @(posedge clk) begin
    if (reset) begin
        internal_out <= 32'd0;
    end else begin
        prev_in <= in;
        out <= internal_out;
        internal_out <= internal_out | (prev_in & ~in);
    end
end

endmodule