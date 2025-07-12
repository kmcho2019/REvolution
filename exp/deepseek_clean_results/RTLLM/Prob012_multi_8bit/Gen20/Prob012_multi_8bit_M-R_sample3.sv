module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Create shifted versions of A for each bit position
    wire [15:0] A_shifted0 = {8'b0, A};
    wire [15:0] A_shifted1 = {7'b0, A, 1'b0};
    wire [15:0] A_shifted2 = {6'b0, A, 2'b0};
    wire [15:0] A_shifted3 = {5'b0, A, 3'b0};
    wire [15:0] A_shifted4 = {4'b0, A, 4'b0};
    wire [15:0] A_shifted5 = {3'b0, A, 5'b0};
    wire [15:0] A_shifted6 = {2'b0, A, 6'b0};
    wire [15:0] A_shifted7 = {1'b0, A, 7'b0};

    // Conditionally add each shifted version based on B bits
    wire [15:0] partial0 = B[0] ? A_shifted0 : 16'b0;
    wire [15:0] partial1 = B[1] ? A_shifted1 : 16'b0;
    wire [15:0] partial2 = B[2] ? A_shifted2 : 16'b0;
    wire [15:0] partial3 = B[3] ? A_shifted3 : 16'b0;
    wire [15:0] partial4 = B[4] ? A_shifted4 : 16'b0;
    wire [15:0] partial5 = B[5] ? A_shifted5 : 16'b0;
    wire [15:0] partial6 = B[6] ? A_shifted6 : 16'b0;
    wire [15:0] partial7 = B[7] ? A_shifted7 : 16'b0;

    // Sum all partial products
    assign product = partial0 + partial1 + partial2 + partial3 +
                    partial4 + partial5 + partial6 + partial7;

endmodule