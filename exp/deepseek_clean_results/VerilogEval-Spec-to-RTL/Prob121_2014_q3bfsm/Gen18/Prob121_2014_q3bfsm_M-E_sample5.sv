module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // Shift register states: [4:0] represents states 100,011,010,001,000
    reg [4:0] state;

    // Next state logic - shift operations
    wire [4:0] next_state;
    assign next_state = reset ? 5'b00001 :  // Reset to state 000 (LSB)
                      (state == 5'b00001) ? (x ? 5'b00010 : 5'b00001) :  // State 000
                      (state == 5'b00010) ? (x ? 5'b10000 : 5'b00010) :  // State 001
                      (state == 5'b00100) ? (x ? 5'b00010 : 5'b00100) :  // State 010
                      (state == 5'b01000) ? (x ? 5'b00100 : 5'b00010) :  // State 011
                      (state == 5'b10000) ? (x ? 5'b10000 : 5'b01000) :  // State 100
                      5'b00001;  // Default to state 000

    // State register
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output logic - states 011 (01000) and 100 (10000)
    assign z = state[4] | state[3];

endmodule