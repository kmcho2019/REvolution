module TopModule (
    input  clk,
    input  x,
    output z
);

    reg [2:0] state;       // state[2]: ff_or, state[1]: ff_and, state[0]: ff_xor
    wire [2:0] next_state;

    // Initialize state to zero for simulation
    initial state = 3'b000;

    // Next state logic for each bit:
    // next_state[0] = x XOR current ff_xor (state[0])
    // next_state[1] = x AND complement of current ff_and (state[1])
    // next_state[2] = x OR complement of current ff_or (state[2])
    assign next_state[0] = x ^ state[0];
    assign next_state[1] = x & (~state[1]);
    assign next_state[2] = x | (~state[2]);

    // Sequential update of the state on posedge clk
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output z is NOR of all flip-flop outputs
    assign z = ~(state[0] | state[1] | state[2]);

endmodule