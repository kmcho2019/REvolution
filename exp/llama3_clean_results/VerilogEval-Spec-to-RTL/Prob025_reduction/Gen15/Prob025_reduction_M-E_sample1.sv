// Novel module to calculate the even parity bit for an 8-bit input byte using a shift-and-XOR approach
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

reg [7:0] shift_reg;  // Shift register to hold the input byte
reg parity_reg;      // Register to hold the accumulated parity

initial begin
    shift_reg = in;  // Initialize the shift register with the input byte
    parity_reg = 1'b0;  // Initialize the parity register to 0
end

always @(posedge in) begin
    for (int i = 0; i < 8; i++) begin
        parity_reg <= parity_reg ^ shift_reg[7];  // XOR the current bit with the accumulated parity
        shift_reg <= {shift_reg[6:0], 1'b0};  // Shift the register one bit to the right
    end
    parity <= parity_reg;  // Assign the final parity to the output
end

endmodule