module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Implement subtraction as A + (~B) + 1 using segmented carry-select adder (CSA)
    wire [63:0] B_neg = ~B;
    wire [7:0]  carry; // carry signals between segments

    // First segment carry-in is cin=1 (due to +1 in two's complement)
    assign carry[0] = 1'b1;

    genvar i;
    generate
        for(i = 0; i < 8; i = i + 1) begin : seg_add
            // Extract 8-bit segments
            wire [7:0] A_seg = A[i*8 +: 8];
            wire [7:0] B_seg = B_neg[i*8 +: 8];
            wire       cin   = carry[i];

            wire [7:0] sum0, sum1;
            wire       cout0, cout1;

            // Compute sums assuming carry_in=0 and carry_in=1
            add8bit u_add0 (.A(A_seg), .B(B_seg), .cin(1'b0), .sum(sum0), .cout(cout0));
            add8bit u_add1 (.A(A_seg), .B(B_seg), .cin(1'b1), .sum(sum1), .cout(cout1));

            // Select correct sum and carry-out based on actual carry-in
            assign result[i*8 +: 8] = (cin == 1'b0) ? sum0 : sum1;
            assign carry[i+1]       = (cin == 1'b0) ? cout0 : cout1;
        end
    endgenerate

    // Overflow detection for subtraction:
    // Overflow if A_sign != B_sign and result_sign != A_sign
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 8-bit adder with carry-in and carry-out
module add8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [8:0] temp = {1'b0, A} + {1'b0, B} + cin;
    assign sum  = temp[7:0];
    assign cout = temp[8];
endmodule