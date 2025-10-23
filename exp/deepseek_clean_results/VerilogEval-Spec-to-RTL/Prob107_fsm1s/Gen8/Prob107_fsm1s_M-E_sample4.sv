module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg [1:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 2'b11; // Initialize to state B (MSB=1)
        end else if (!in) begin
            // Rotate left when input is 0
            shift_reg <= {shift_reg[0], shift_reg[1]};
        end
        // When input is 1, maintain current state (implicit)
    end

    assign out = shift_reg[1]; // Output is MSB of shift register

endmodule