// Module to reverse the bit ordering of an 8-bit input using a shift register
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);
    reg [7:0] temp;  // Temporary register to hold the reversed bits

    // Use a shift register to reverse the bit order
    always @(*) begin
        temp = 8'b0;  // Initialize the temporary register
        for (int i = 0; i < 8; i++) begin
            temp = (temp << 1) | in[7 - i];  // Shift the input bits into the temporary register
        end
        out = temp;  // Assign the reversed bits to the output
    end
endmodule