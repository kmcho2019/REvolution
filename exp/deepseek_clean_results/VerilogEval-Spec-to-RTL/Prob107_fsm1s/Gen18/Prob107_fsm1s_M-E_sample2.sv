module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg [1:0] state_shift;

    // Shift register based state transitions
    always @(posedge clk) begin
        if (reset) begin
            state_shift <= 2'b11; // Initialize to state B
        end else begin
            if (state_shift[1]) begin  // Current state is B
                state_shift <= {state_shift[0], in}; // Shift left
            end else begin             // Current state is A
                state_shift <= {in, state_shift[1]}; // Shift right
            end
        end
    end

    // Output is MSB of shift register
    assign out = state_shift[1];

endmodule