module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    wire [3:0] A_onehot, B_onehot;
    
    // Convert A to one-hot encoding
    assign A_onehot = (A == 2'b00) ? 4'b0001 :
                     (A == 2'b01) ? 4'b0010 :
                     (A == 2'b10) ? 4'b0100 :
                                     4'b1000;
    
    // Convert B to one-hot encoding
    assign B_onehot = (B == 2'b00) ? 4'b0001 :
                     (B == 2'b01) ? 4'b0010 :
                     (B == 2'b10) ? 4'b0100 :
                                     4'b1000;
    
    // Check if any one-hot bit matches
    assign z = |(A_onehot & B_onehot);
endmodule