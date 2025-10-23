// Novel module to calculate the even parity bit for an 8-bit input byte using a shift register approach
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

reg [7:0] temp;  // Temporary register to hold the input byte
reg parity_temp;  // Temporary register to hold the running XOR result
integer i;  // Loop counter

always @(*) begin
    temp = in;  // Initialize the temporary register with the input byte
    parity_temp = 1'b0;  // Initialize the temporary parity register to 0
    
    // Iterate over each bit in the input byte
    for (i = 0; i < 8; i = i + 1) begin
        // Update the running XOR result
        parity_temp = parity_temp ^ temp[0];
        
        // Shift the bits of the temporary register one position to the right
        temp = temp >> 1;
    end
    
    // Assign the final parity bit to the output
    parity = parity_temp;
end

endmodule