module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg [1:0] shift_reg;

    always @(posedge clk) begin
        if (reset)
            shift_reg <= 2'b11;  // Initialize to state B
        else
            shift_reg <= {shift_reg[0] ^ ~in, in};  // Rotate with conditional inversion
    end

    assign out = ~shift_reg[1];  // Output is complement of MSB (state bit)

endmodule