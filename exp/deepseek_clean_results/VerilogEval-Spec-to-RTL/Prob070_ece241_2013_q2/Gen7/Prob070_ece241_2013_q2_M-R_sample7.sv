module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-products using equality checks
    assign out_sop = ({a,b,c,d} == 4'b0010) |  // 2
                     ({a,b,c,d} == 4'b0111) |  // 7
                     ({a,b,c,d} == 4'b1111);   // 15

    // Product-of-sums via complement function
    wire complement;
    assign complement = ({a,b,c,d} == 4'b0000) |  // 0
                       ({a,b,c,d} == 4'b0001) |  // 1
                       ({a,b,c,d} == 4'b0100) |  // 4
                       ({a,b,c,d} == 4'b0101) |  // 5
                       ({a,b,c,d} == 4'b0110) |  // 6
                       ({a,b,c,d} == 4'b1001) |  // 9
                       ({a,b,c,d} == 4'b1010) |  // 10
                       ({a,b,c,d} == 4'b1101) |  // 13
                       ({a,b,c,d} == 4'b1110);   // 14

    assign out_pos = ~complement;

endmodule