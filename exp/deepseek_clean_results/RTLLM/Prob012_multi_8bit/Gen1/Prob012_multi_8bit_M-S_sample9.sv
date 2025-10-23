module multi_8bit (
    input wire [7:0] A,
    input wire [7:0] B,
    output wire [15:0] product
);

    // Pre-calculate all shifted versions of A
    wire [15:0] shifted_A [0:7];
    assign shifted_A[0] = {8'b0, A};
    assign shifted_A[1] = shifted_A[0] << 1;
    assign shifted_A[2] = shifted_A[1] << 1;
    assign shifted_A[3] = shifted_A[2] << 1;
    assign shifted_A[4] = shifted_A[3] << 1;
    assign shifted_A[5] = shifted_A[4] << 1;
    assign shifted_A[6] = shifted_A[5] << 1;
    assign shifted_A[7] = shifted_A[6] << 1;

    // Select and sum partial products based on B bits
    assign product = (B[0] ? shifted_A[0] : 16'b0) +
                    (B[1] ? shifted_A[1] : 16'b0) +
                    (B[2] ? shifted_A[2] : 16'b0) +
                    (B[3] ? shifted_A[3] : 16'b0) +
                    (B[4] ? shifted_A[4] : 16'b0) +
                    (B[5] ? shifted_A[5] : 16'b0) +
                    (B[6] ? shifted_A[6] : 16'b0) +
                    (B[7] ? shifted_A[7] : 16'b0);

endmodule