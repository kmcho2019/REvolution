module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg [1:0] shift_reg;  // Shift register implementation

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 2'b11;  // Reset to state B ('11')
        end else begin
            // Circular shift with new bit determined by transition logic
            shift_reg <= {shift_reg[0], 
                         (shift_reg[1] & in) | (~shift_reg[1] & ~in)};
        end
    end

    // Output is MSB of shift register
    assign out = shift_reg[1];

endmodule