module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // Shift register state representation (one-hot)
    reg [4:0] state;

    // Next state logic
    wire [4:0] next_state;
    assign next_state = 
        (state == 5'b00001) ? (x ? 5'b00010 : 5'b00001) :  // State 0
        (state == 5'b00010) ? (x ? 5'b10000 : 5'b00010) :  // State 1
        (state == 5'b00100) ? (x ? 5'b00010 : 5'b00100) :  // State 2
        (state == 5'b01000) ? (x ? 5'b00100 : 5'b00010) :  // State 3
        (state == 5'b10000) ? (x ? 5'b10000 : 5'b01000) :  // State 4
        5'b00001;  // Default to state 0

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 5'b00001;  // Reset to state 0
        else
            state <= next_state;
    end

    // Output is high for states 3 (01000) and 4 (10000)
    assign z = state[3] | state[4];

endmodule