module TopModule(
    input clk,
    input x,
    output reg z
);

reg [2:0] state;

always @(posedge clk) begin
    reg xor_out, and_out, or_out;
    xor_out = x ^ state[0];
    and_out = x & ~state[1];
    or_out = x | ~state[2];
    state[0] <= xor_out;
    state[1] <= and_out;
    state[2] <= or_out;
end

always @(*) begin
    z = ~(state[0] | state[1] | state[2]);
end

initial begin
    state = 3'b000;
end

endmodule