module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;
    assign diff = A - B;
    
    assign A_equal = (diff == 4'd0);
    assign A_greater = (A_equal == 1'b0) && ((A[3] > B[3]) || 
                                            (A[3] == B[3] && A[2] > B[2]) || 
                                            (A[3:2] == 2'b00 && A[1] > B[1]) || 
                                            (A[3:1] == 4'b0000 && A[0] > B[0]));
    assign A_less = (A_equal == 1'b0) && ((A[3] < B[3]) || 
                                          (A[3] == B[3] && A[2] < B[2]) || 
                                          (A[3:2] == 2'b00 && A[1] < B[1]) || 
                                          (A[3:1] == 4'b0000 && A[0] < B[0]));

endmodule