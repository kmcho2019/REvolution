// TopModule: A Verilog module to reverse the bit ordering of a 100-bit input vector using a shift register.
module TopModule(
    input  [99:0] in,  // 100-bit input vector
    output [99:0] out  // 100-bit output vector
);

    reg [99:0] shift_reg;  // 100-bit shift register

    always @(in) begin
        // Initialize the shift register
        shift_reg = 0;

        // Shift the bits of the input vector into the shift register
        for (int i = 0; i < 100; i++) begin
            // Shift the current bit into the shift register
            shift_reg = (shift_reg << 1) | in[99 - i];
        end

        // Assign the bits of the shift register to the output vector
        out = shift_reg;
    end

endmodule