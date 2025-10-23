module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg [1:0] state_shift;  // Shift register for state representation

    always @(posedge clk) begin
        if (reset) begin
            state_shift <= 2'b01;  // Initialize to state B
        end else begin
            // Shift in next state based on current state and input
            state_shift <= {state_shift[0], 
                           (state_shift[0] & in) | (state_shift[1] & ~in)};
        end
    end

    // Output is inverse of LSB (0 for A, 1 for B)
    assign out = ~state_shift[0];

endmodule