module TopModule (
    input [2:0] in,
    output [1:0] out
);

    // Direct truth table implementation
    assign out = (in == 3'b000) ? 2'b00 :
                (in == 3'b001) ? 2'b01 :
                (in == 3'b010) ? 2'b01 :
                (in == 3'b011) ? 2'b10 :
                (in == 3'b100) ? 2'b01 :
                (in == 3'b101) ? 2'b10 :
                (in == 3'b110) ? 2'b10 :
                                 2'b11;

endmodule