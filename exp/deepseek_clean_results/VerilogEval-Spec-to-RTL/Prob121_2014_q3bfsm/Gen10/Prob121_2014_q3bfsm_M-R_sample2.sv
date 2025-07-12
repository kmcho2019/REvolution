module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // One-hot encoded states
    reg [4:0] state;  // S0-S4 for states 000-100 respectively

    // Next state combinational logic
    wire [4:0] next_state;
    assign next_state[0] = ~reset & ((state[0] & ~x) | 
                                        (state[1] & ~x) | 
                                        (state[3] & ~x));
    assign next_state[1] = ~reset & ((state[0] & x) | 
                                        (state[1] & ~x) | 
                                        (state[2] & x) | 
                                        (state[3] & ~x));
    assign next_state[2] = ~reset & ((state[2] & ~x) | 
                                        (state[3] & x));
    assign next_state[3] = ~reset & ((state[4] & ~x));
    assign next_state[4] = ~reset & ((state[1] & x) | 
                                        (state[4] & x));

    // State update
    always @(posedge clk) begin
        if (reset)
            state <= 5'b00001;  // Reset to S0 (000)
        else
            state <= next_state;
    end

    // Output logic (states S3 and S4)
    assign z = state[3] | state[4];

endmodule