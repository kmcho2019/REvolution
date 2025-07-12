module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

wire [19:0] partial_remainder [0:3];  // Extra bits for carry-save
wire [15:0] quotient [0:3];
wire [7:0] divisor_ext = B;

// Stage 0: Process bits [15:12]
assign partial_remainder[0] = {4'b0, A[15:12], 8'b0};
wire [8:0] diff0 = partial_remainder[0][19:11] - {1'b0, divisor_ext};
assign quotient[0][15:12] = ~diff0[8] ? 4'b0001 : 4'b0000;
assign partial_remainder[1] = ~diff0[8] ? 
    {partial_remainder[0][18:0], 1'b0} : 
    {diff0[7:0], partial_remainder[0][10:0], 1'b0};

// Stage 1: Process bits [11:8]
wire [8:0] diff1 = partial_remainder[1][19:11] - {1'b0, divisor_ext};
assign quotient[1][11:8] = ~diff1[8] ? 4'b0001 : 4'b0000;
assign partial_remainder[2] = ~diff1[8] ? 
    {partial_remainder[1][18:0], 1'b0} : 
    {diff1[7:0], partial_remainder[1][10:0], 1'b0};

// Stage 2: Process bits [7:4]
wire [8:0] diff2 = partial_remainder[2][19:11] - {1'b0, divisor_ext};
assign quotient[2][7:4] = ~diff2[8] ? 4'b0001 : 4'b0000;
assign partial_remainder[3] = ~diff2[8] ? 
    {partial_remainder[2][18:0], 1'b0} : 
    {diff2[7:0], partial_remainder[2][10:0], 1'b0};

// Stage 3: Process bits [3:0]
wire [8:0] diff3 = partial_remainder[3][19:11] - {1'b0, divisor_ext};
assign quotient[3][3:0] = ~diff3[8] ? 4'b0001 : 4'b0000;
wire [19:0] final_remainder = ~diff3[8] ? 
    {partial_remainder[3][18:0], 1'b0} : 
    {diff3[7:0], partial_remainder[3][10:0], 1'b0};

// Combine results
assign result = {quotient[0][15:12], quotient[1][11:8], 
                quotient[2][7:4], quotient[3][3:0]};
assign odd = (B == 8'b0) ? 16'hFFFF : final_remainder[15:0];

endmodule