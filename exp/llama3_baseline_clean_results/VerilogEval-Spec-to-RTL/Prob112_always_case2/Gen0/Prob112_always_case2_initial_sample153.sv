module TopModule(
    input [3:0] in,
    output [1:0] pos
);

    always_comb begin
        casez(in)
            4'b1??? : pos = 2'b11;  // Most significant bit is 1
            4'b01?? : pos = 2'b10;  // Second bit is 1
            4'b001? : pos = 2'b01;  // Third bit is 1
            4'b0001 : pos = 2'b00;  // Least significant bit is 1
            default : pos = 2'b00;  // No 1 bit found
        endcase
    end

endmodule