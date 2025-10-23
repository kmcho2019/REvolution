module TopModule(
    input clk,
    input x,
    output reg z
);

reg xor_q = 0, and_q = 0, or_q = 0;

// Sequential logic
always @(posedge clk) begin
    reg xor_temp, and_temp, or_temp;
    xor_temp = x ^ xor_q;
    and_temp = x & ~and_q;
    or_temp = x | ~or_q;
    xor_q <= xor_temp;
    and_q <= and_temp;
    or_q <= or_temp;
    z <= ~(xor_temp | and_temp | or_temp); // Calculate z after updating flip-flop outputs
end

endmodule