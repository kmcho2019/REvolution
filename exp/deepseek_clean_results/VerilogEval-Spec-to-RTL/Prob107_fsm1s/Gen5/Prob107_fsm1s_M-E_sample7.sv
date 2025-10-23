module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg [1:0] state_shift;

    // Output is MSB of shift register
    assign out = state_shift[1];

    always @(posedge clk) begin
        if (reset) begin
            state_shift <= 2'b11; // Initialize to state B (out=1)
        end else begin
            // Shift left and insert next state at LSB
            state_shift <= {state_shift[0], 
                           (state_shift[1] & in) | (~state_shift[1] & in)};
            // Equivalent to:
            // if (state_shift[1]) state_shift[0] <= in;  // State B
            // else state_shift[0] <= in;                 // State A
        end
    end

endmodule