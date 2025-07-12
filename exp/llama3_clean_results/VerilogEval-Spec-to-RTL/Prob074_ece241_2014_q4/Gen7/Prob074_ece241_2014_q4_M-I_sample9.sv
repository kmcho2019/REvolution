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
    // Compute the outputs of the gates
    reg xor_out, and_out, or_out;
    xor_out = x ^ state[0];
    and_out = x & ~state[1];
    or_out = x | ~state[2];
    
    // Update the state of the flip-flops
    state[0] <= xor_out;
    state[1] <= and_out;
    state[2] <= or_out;
    
    // Compute z as the NOR of the updated state
    z <= ~(state[0] | state[1] | state[2]);
end

endmodule