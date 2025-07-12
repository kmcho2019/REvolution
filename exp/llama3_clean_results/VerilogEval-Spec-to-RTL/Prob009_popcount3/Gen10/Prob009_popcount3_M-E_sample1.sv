// Module to count the number of '1's in a 3-bit input vector using a Lookup Table (LUT)
module TopModule(
    input [2:0] in,  // 3-bit input vector
    output [1:0] out // 2-bit output vector to hold the count
);

    // Define the LUT as a case statement that maps input patterns to their population counts
    always @(*) begin
        case(in)
            3'b000: out = 2'b00; // Count for input 000 is 0
            3'b001, 3'b010, 3'b100: out = 2'b01; // Count for inputs with one '1' is 1
            3'b011, 3'b101, 3'b110: out = 2'b10; // Count for inputs with two '1's is 2
            3'b111: out = 2'b11; // Count for input 111 is 3
        endcase
    end

endmodule