module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // 2-bit shift register: [1] is current state, [0] is next state
    reg [1:0] state_shift;

    // Output is directly the MSB of the shift register
    assign out = state_shift[1];

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize to state B (1)
            state_shift <= 2'b11;
        end else begin
            // Shift operation with conditional inversion
            state_shift <= {state_shift[0], 
                           in ? state_shift[1] : ~state_shift[1]};
        end
    end

endmodule