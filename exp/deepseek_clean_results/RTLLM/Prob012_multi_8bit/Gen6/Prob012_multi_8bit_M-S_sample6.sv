module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    assign product = (B[0] ? {8'b0, A} : 16'b0) +
                    (B[1] ? {7'b0, A, 1'b0} : 16'b0) +
                    (B[2] ? {6'b0, A, 2'b0} : 16'b0) +
                    (B[3] ? {5'b0, A, 3'b0} : 16'b0) +
                    (B[4] ? {4'b0, A, 4'b0} : 16'b0) +
                    (B[5] ? {3'b0, A, 5'b0} : 16'b0) +
                    (B[6] ? {2'b0, A, 6'b0} : 16'b0) +
                    (B[7] ? {1'b0, A, 7'b0} : 16'b0);

endmodule