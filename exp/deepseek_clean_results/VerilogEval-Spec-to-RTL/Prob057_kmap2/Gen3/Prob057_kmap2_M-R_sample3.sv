module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    wire [3:0] abcd = {a,b,c,d};
    
    assign out = (abcd == 4'b0000) ? 1 :
                 (abcd == 4'b0001) ? 1 :
                 (abcd == 4'b0010) ? 1 :
                 (abcd == 4'b0011) ? 0 :
                 (abcd == 4'b0100) ? 1 :
                 (abcd == 4'b0101) ? 0 :
                 (abcd == 4'b0110) ? 1 :
                 (abcd == 4'b0111) ? 0 :
                 (abcd == 4'b1000) ? 1 :
                 (abcd == 4'b1001) ? 1 :
                 (abcd == 4'b1010) ? 0 :
                 (abcd == 4'b1011) ? 0 :
                 (abcd == 4'b1100) ? 0 :
                 (abcd == 4'b1101) ? 1 :
                 (abcd == 4'b1110) ? 1 :
                 (abcd == 4'b1111) ? 1 :
                 0;
endmodule