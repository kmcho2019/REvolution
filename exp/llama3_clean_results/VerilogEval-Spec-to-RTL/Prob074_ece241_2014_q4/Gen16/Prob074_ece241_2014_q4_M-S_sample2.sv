module TopModule(
    input clk,
    input x,
    output reg z
);

reg xor_q = 0, and_q = 0, or_q = 0;
wire xor_out, and_out, or_out;

// Combinational logic
assign xor_out = x ^ xor_q;
assign and_out = x & ~and_q;
assign or_out = x | ~or_q;

// Sequential logic and output calculation
always @(posedge clk) begin
    xor_q <= xor_out;
    and_q <= and_out;
    or_q <= or_out;
    z <= ~(xor_q | and_q | or_q);
end

endmodule