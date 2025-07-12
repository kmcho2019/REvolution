// Refactored module to reverse the bit ordering of an 8-bit input
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);
    // Use a for loop to assign the bits of the input to the output in reverse order
    // This approach maintains efficiency and minimalism while presenting the logic differently
    always @(*) begin
        for (int i = 0; i < 8; i++) begin
            out[7-i] = in[i];
        end
    end
    
    // This refactored module performs the bit reversal operation with minimal logic
    // The use of a for loop ensures clarity and efficiency, adhering to best practices
endmodule