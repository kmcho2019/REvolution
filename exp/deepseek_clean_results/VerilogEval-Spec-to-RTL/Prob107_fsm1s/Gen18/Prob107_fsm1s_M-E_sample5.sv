module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg [1:0] shift_reg;  // [1] is previous state, [0] is current state

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 2'b10;  // Initialize to state B (0)
        end else begin
            // Shift in next state: if current state is A, shift in 'in', else shift in '~in'
            shift_reg <= {shift_reg[0], shift_reg[0] ? in : ~in};
        end
    end

    // Output is complement of current state (LSB)
    assign out = ~shift_reg[0];

endmodule