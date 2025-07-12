module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Use a lookup table approach to calculate the population count
    always @(*) begin
        case (in)
            3'b000: out = 2'b00;
            3'b001, 3'b010, 3'b100: out = 2'b01;
            3'b011, 3'b101, 3'b110: out = 2'b10;
            3'b111: out = 2'b11;
        endcase
    end

    // This implementation uses a lookup table approach to directly map the input combinations to their corresponding population counts.
    // It avoids the need for arithmetic operations, potentially reducing area usage and power consumption.

endmodule