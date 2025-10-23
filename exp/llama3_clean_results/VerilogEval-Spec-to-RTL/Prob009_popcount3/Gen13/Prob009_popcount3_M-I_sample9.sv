module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Using a case statement to directly calculate the population count
    always @(*) begin
        case ({in[2], in[1], in[0]})
            3'b000: out = 2'b00;
            3'b001, 3'b010, 3'b100: out = 2'b01;
            3'b011, 3'b101, 3'b110: out = 2'b10;
            3'b111: out = 2'b11;
        endcase
    end

    // This implementation uses a case statement to directly calculate the population count of the input vector 'in' and assign it to 'out'.
    // It aims to minimize the number of operations required, potentially leading to reductions in area and power consumption.

endmodule