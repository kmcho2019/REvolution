// Novel implementation using a shift register to reverse the bit ordering
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out  // 8-bit output vector
);

    reg [7:0] shift_reg; // Internal shift register

    always @(in) begin
        // Initialize the shift register with zeros
        shift_reg = 8'b0;
        
        // Shift the input bits into the register to reverse the order
        for (int i = 0; i < 8; i++) begin
            // Shift the current bit of the input into the LSB of the shift register
            shift_reg[7 - i] = in[i];
        end
        
        // Assign the reversed bits to the output vector
        out = shift_reg;
    end

endmodule