module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    q <= r? 1'b0 : d; // Capture the reset-conditioned input on the positive edge of the clock
end

endmodule