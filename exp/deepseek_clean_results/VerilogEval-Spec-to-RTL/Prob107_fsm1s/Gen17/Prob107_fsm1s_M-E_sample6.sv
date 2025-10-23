module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // 2-bit shift register implementation
    reg [1:0] state_shift;

    always @(posedge clk) begin
        if (reset) begin
            state_shift <= 2'b10; // Initialize to state B
        end else begin
            // Shift in the next state bit
            state_shift <= {state_shift[0], 
                          (state_shift[1] ? ~in : in)};
        end
    end

    // Output is the MSB of the shift register
    assign out = state_shift[1];

endmodule