module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Form 4-bit address from inputs
    wire [3:0] address = {a,b,c,d};

    // SOP implementation - only specified true cases
    assign out_sop = (address == 4'b0010) |  // 2
                    (address == 4'b0111) |  // 7
                    (address == 4'b1111);   // 15

    // POS implementation - invert specified false cases
    assign out_pos = ~((address == 4'b0000) |  // 0
                      (address == 4'b0001) |  // 1
                      (address == 4'b0100) |  // 4
                      (address == 4'b0101) |  // 5
                      (address == 4'b0110) |  // 6
                      (address == 4'b1001) |  // 9
                      (address == 4'b1010) |  // 10
                      (address == 4'b1101) |  // 13
                      (address == 4'b1110));  // 14

endmodule