module TopModule (
    input clk,
    input x,
    output z
);

    // State register: [xor_ff, and_ff, or_ff]
    reg [2:0] state = 3'b000;  // Initialize all FFs to 0
    
    // Next state computation
    wire [2:0] next_state;
    assign next_state[2] = x ^ state[2];      // XOR with x and xor_ff
    assign next_state[1] = x & ~state[1];     // AND with x and ~and_ff
    assign next_state[0] = x | ~state[0];     // OR with x and ~or_ff
    
    // State update on clock edge
    always @(posedge clk) begin
        state <= next_state;
    end
    
    // Output is NOR of all flip-flop outputs
    assign z = ~(|state);
    
endmodule