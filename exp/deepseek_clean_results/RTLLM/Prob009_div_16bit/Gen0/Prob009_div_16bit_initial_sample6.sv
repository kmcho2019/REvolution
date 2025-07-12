module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    reg [15:0] quotient;
    reg [15:0] remainder;
    reg [7:0] divisor;

    always @(*) begin
        divisor = B;
        remainder = 16'b0;
        quotient = 16'b0;

        // Non-restoring division algorithm
        remainder[15:8] = 8'b0;
        remainder[7:0] = A[15:8];
        quotient[15] = (remainder[7:0] >= divisor);
        remainder[7:0] = quotient[15] ? (remainder[7:0] - divisor) : remainder[7:0];

        remainder = remainder << 1;
        remainder[0] = A[7];
        quotient[14] = (remainder[7:0] >= divisor);
        remainder[7:0] = quotient[14] ? (remainder[7:0] - divisor) : remainder[7:0];

        remainder = remainder << 1;
        remainder[0] = A[6];
        quotient[13] = (remainder[7:0] >= divisor);
        remainder[7:0] = quotient[13] ? (remainder[7:0] - divisor) : remainder[7:0];

        remainder = remainder << 1;
        remainder[0] = A[5];
        quotient[12] = (remainder[7:0] >= divisor);
        remainder[7:0] = quotient[12] ? (remainder[7:0] - divisor) : remainder[7:0];

        remainder = remainder << 1;
        remainder[0] = A[4];
        quotient[11] = (remainder[7:0] >= divisor);
        remainder[7:0] = quotient[11] ? (remainder[7:0] - divisor) : remainder[7:0];

        remainder = remainder << 1;
        remainder[0] = A[3];
        quotient[10] = (remainder[7:0] >= divisor);
        remainder[7:0] = quotient[10] ? (remainder[7:0] - divisor) : remainder[7:0];

        remainder = remainder << 1;
        remainder[0] = A[2];
        quotient[9] = (remainder[7:0] >= divisor);
        remainder[7:0] = quotient[9] ? (remainder[7:0] - divisor) : remainder[7:0];

        remainder = remainder << 1;
        remainder[0] = A[1];
        quotient[8] = (remainder[7:0] >= divisor);
        remainder[7:0] = quotient[8] ? (remainder[7:0] - divisor) : remainder[7:0];

        remainder = remainder << 1;
        remainder[0] = A[0];
        quotient[7] = (remainder[7:0] >= divisor);
        remainder[7:0] = quotient[7] ? (remainder[7:0] - divisor) : remainder[7:0];

        // Lower 8 bits (integer division)
        quotient[6] = (remainder[7:0] >= divisor);
        remainder[7:0] = quotient[6] ? (remainder[7:0] - divisor) : remainder[7:0];

        quotient[5] = (remainder[7:0] >= divisor);
        remainder[7:0] = quotient[5] ? (remainder[7:0] - divisor) : remainder[7:0];

        quotient[4] = (remainder[7:0] >= divisor);
        remainder[7:0] = quotient[4] ? (remainder[7:0] - divisor) : remainder[7:0];

        quotient[3] = (remainder[7:0] >= divisor);
        remainder[7:0] = quotient[3] ? (remainder[7:0] - divisor) : remainder[7:0];

        quotient[2] = (remainder[7:0] >= divisor);
        remainder[7:0] = quotient[2] ? (remainder[7:0] - divisor) : remainder[7:0];

        quotient[1] = (remainder[7:0] >= divisor);
        remainder[7:0] = quotient[1] ? (remainder[7:0] - divisor) : remainder[7:0];

        quotient[0] = (remainder[7:0] >= divisor);
        remainder[7:0] = quotient[0] ? (remainder[7:0] - divisor) : remainder[7:0];
    end

    assign result = quotient;
    assign odd = {8'b0, remainder[7:0]};

endmodule