module TopModule(
    input clk,
    input x,
    output reg z
);

reg [2:0] state;

initial state = 0;

always @(posedge clk) begin
    state[0] <= x ^ state[0];
    state[1] <= x & ~state[1];
    state[2] <= x | ~state[2];
end

always @(*) begin
    z = ~( (x ^ state[0]) | (x & ~state[1]) | (x | ~state[2]) );
end

endmodule