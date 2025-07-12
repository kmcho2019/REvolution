module TopModule (
    input clk,
    input x,
    output reg z
);

    // State register (3 bits: [xor, and, or])
    reg [2:0] state = 3'b0;
    reg [2:0] next_state;

    // Gate outputs (registered)
    reg xor_gate, and_gate, or_gate;

    // Combinational logic for next state
    always @(*) begin
        // Gate computations using previous state
        xor_gate = x ^ state[2];  // XOR with previous xor_out
        and_gate = x & ~state[1]; // AND with previous and_out complement
        or_gate = x | ~state[0];  // OR with previous or_out complement

        // Next state is simply the gate outputs
        next_state = {xor_gate, and_gate, or_gate};
    end

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        state <= next_state;
        z <= ~(|next_state);  // NOR of all state bits
    end

endmodule