module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output reg  [63:0] result,
    output reg         overflow
);

    localparam SIGN_BIT = 63;

    wire sign_A = A[SIGN_BIT];
    wire sign_B = B[SIGN_BIT];
    wire sign_res;

    always @* begin
        result = A - B;
        // Extract result sign bit
        overflow = 1'b0;
        // Overflow occurs if signs of A and B differ, and sign of result differs from A
        if ((sign_A != sign_B) && (result[SIGN_BIT] != sign_A)) begin
            overflow = 1'b1;
        end
    end

endmodule