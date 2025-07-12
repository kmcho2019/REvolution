module TopModule(
    input clk,
    input x,
    output reg z
);

reg [2:0] state;

initial begin
    state = 0;
end

always @(posedge clk) begin
    // Compute the outputs of the gates directly
    state[0] <= x ^ state[0];
    state[1] <= x & ~state[1];
    state[2] <= x | ~state[2];
    
    // Compute z directly as the output of the NOR gate
    z <= ~( (x ^ state[0]) | (x & ~state[1]) | (x | ~state[2]) );
end

endmodule