module TopModule (
    input clk,
    input x,
    output z
);

    // State register: [xor_state, and_state, or_state]
    reg [2:0] state = 3'b000;
    
    always @(posedge clk) begin
        // Update each state bit with its respective gate logic
        state[2] <= x ^ state[2];      // XOR gate
        state[1] <= x & ~state[1];     // AND gate
        state[0] <= x | ~state[0];      // OR gate (with complemented feedback)
    end
    
    // Output is NOR of all state bits
    assign z = ~(|state);

endmodule