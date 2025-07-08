module TopModule(
    input [3:0] x,
    output f
);

    // Implement f based on K-map minterms
    assign f = (x == 4'b0000) ||
               (x == 4'b0010) ||
               (x == 4'b1100) ||
               (x == 4'b1101) ||
               (x == 4'b1111) ||
               (x == 4'b1000) ||
               (x == 4'b1001) ||
               (x == 4'b1010);

endmodule