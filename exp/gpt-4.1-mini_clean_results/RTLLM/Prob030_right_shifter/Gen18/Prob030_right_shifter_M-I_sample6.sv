module right_shifter (
    input  wire       clk,
    input  wire       rst_n,  // Active low synchronous reset
    input  wire       en,     // Enable signal for shifting
    input  wire       d,
    output reg  [7:0] q
);

always @(posedge clk) begin
    if (!rst_n) begin
        q <= 8'b0;
    end else if (en) begin
        q <= {d, q[7:1]};
    end
    // else retain previous value (no shift)
end

endmodule