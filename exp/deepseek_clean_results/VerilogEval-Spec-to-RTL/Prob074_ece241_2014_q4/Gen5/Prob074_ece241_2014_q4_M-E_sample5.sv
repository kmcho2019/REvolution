module TopModule (
    input clk,
    input x,
    output z
);

    // Unified 3-bit register for all states
    reg [2:0] state;
    
    // Feedback signals from each flip-flop
    wire xor_fb = state[0];
    wire and_fb = ~state[1];
    wire or_fb = ~state[2];
    
    // Next state logic
    wire [2:0] next_state = {
        x | or_fb,    // OR path
        x & and_fb,   // AND path
        x ^ xor_fb    // XOR path
    };
    
    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        state <= next_state;
    end
    
    // Output logic - 3-input NOR of all flip-flop outputs
    assign z = ~(|state);
    
    // Initialization (synthesis-friendly)
    initial begin
        state = 3'b0;
    end

endmodule