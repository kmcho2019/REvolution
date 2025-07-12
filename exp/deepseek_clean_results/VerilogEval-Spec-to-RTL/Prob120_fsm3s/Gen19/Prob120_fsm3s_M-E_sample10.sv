module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Gray code state encoding: A=00, B=01, C=11, D=10
    reg [1:0] state;

    // Next state computation using bitwise operations
    wire [1:0] next_state;
    assign next_state = in ? 
        ({state[1], ~state[0]} ^ {state[1] & state[0], 1'b0}) :  // in=1 case
        (state ^ {1'b0, state[1]});                              // in=0 case

    // State register update
    always @(posedge clk) begin
        if (reset)
            state <= 2'b00;  // Reset to state A (00)
        else
            state <= next_state;
    end

    // Output logic - only high in state D (10)
    assign out = (state == 2'b10);

endmodule