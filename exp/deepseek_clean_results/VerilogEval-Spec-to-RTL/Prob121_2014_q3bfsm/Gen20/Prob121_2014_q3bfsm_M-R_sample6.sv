module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // One-hot state encoding
    localparam S0 = 5'b00001;
    localparam S1 = 5'b00010;
    localparam S2 = 5'b00100;
    localparam S3 = 5'b01000;
    localparam S4 = 5'b10000;

    reg [4:0] current_state, next_state;

    // Next state logic (parallel assignments)
    assign next_state[0] = ~reset & ((current_state == S0 & ~x) | 
                                    (current_state == S0 & x & ~current_state[1]));  // S0 transitions
    assign next_state[1] = ~reset & ((current_state == S0 & x) | 
                                    (current_state == S1 & ~x) | 
                                    (current_state == S2 & x) | 
                                    (current_state == S3 & ~x));  // S1 transitions
    assign next_state[2] = ~reset & ((current_state == S2 & ~x) | 
                                    (current_state == S3 & x) | 
                                    (current_state == S4 & ~x));  // S2/S3 transitions
    assign next_state[3] = ~reset & (current_state == S4 & ~x);   // S3 transition
    assign next_state[4] = ~reset & ((current_state == S1 & x) | 
                                    (current_state == S4 & x));   // S4 transitions

    // State register
    always @(posedge clk) begin
        if (reset)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Output logic
    assign z = current_state[3] | current_state[4];  // S3 or S4

endmodule