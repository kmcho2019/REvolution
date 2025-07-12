// Module to count the number of '1's in a 3-bit input vector using a lookup table
module TopModule(
    input [2:0] in,  // 3-bit input vector
    output [1:0] out // 2-bit output vector to hold the count
);

    // Use a case statement to implement a lookup table for population count
    always @(*) begin
        case(in)
            3'b000: out = 2'b00; // 0 '1's
            3'b001, 3'b010, 3'b100: out = 2'b01; // 1 '1'
            3'b011, 3'b101, 3'b110: out = 2'b10; // 2 '1's
            3'b111: out = 2'b11; // 3 '1's
        endcase
    end

endmodule