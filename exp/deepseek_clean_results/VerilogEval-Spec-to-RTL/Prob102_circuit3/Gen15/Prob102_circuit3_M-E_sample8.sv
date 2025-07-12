module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire [3:0] sel = {a,b,c,d};
    
    assign q = (sel == 4'b0101) ? 1'b1 :  // 5
               (sel == 4'b0110) ? 1'b1 :  // 6
               (sel == 4'b0111) ? 1'b1 :  // 7
               (sel == 4'b1001) ? 1'b1 :  // 9
               (sel == 4'b1010) ? 1'b1 :  // 10
               (sel == 4'b1011) ? 1'b1 :  // 11
               (sel == 4'b1101) ? 1'b1 :  // 13
               (sel == 4'b1110) ? 1'b1 :  // 14
               (sel == 4'b1111) ? 1'b1 :  // 15
               1'b0;

endmodule