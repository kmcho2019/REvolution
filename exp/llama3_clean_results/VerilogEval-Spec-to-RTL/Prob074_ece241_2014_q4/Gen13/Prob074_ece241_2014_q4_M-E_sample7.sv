module TopModule(
    input clk,
    input x,
    output z
);

reg [2:0] state = 3'b000;

always @(posedge clk) begin
    state[0] <= x ^ state[0];
    state[1] <= x & ~state[1];
    state[2] <= x | ~state[2];
end

assign z = ~(state[0] | state[1] | state[2]);

endmodule