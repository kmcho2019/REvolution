module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg [1:0] state_shift;

    always @(posedge clk) begin
        if (reset) begin
            state_shift <= 2'b00;  // Reset to state B
        end else begin
            // Shift in the input, creating implicit state transitions
            state_shift <= {state_shift[0], in};
        end
    end

    // Output is complement of LSB (0 for A, 1 for B)
    assign out = ~state_shift[0];

endmodule