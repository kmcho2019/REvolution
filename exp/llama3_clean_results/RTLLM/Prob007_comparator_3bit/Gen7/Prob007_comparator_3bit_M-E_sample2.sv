module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

// Bit-wise comparator sub-module
module bit_comparator(
    input A_bit,
    input B_bit,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

always @(*)
begin
    if (A_bit > B_bit) begin
        A_greater = 1'b1;
        A_equal = 1'b0;
        A_less = 1'b0;
    end else if (A_bit == B_bit) begin
        A_greater = 1'b0;
        A_equal = 1'b1;
        A_less = 1'b0;
    end else begin
        A_greater = 1'b0;
        A_equal = 1'b0;
        A_less = 1'b1;
    end
end

endmodule

// Result combiner sub-module
module result_combiner(
    input [2:0] A_greater,
    input [2:0] A_equal,
    input [2:0] A_less,
    output reg A_greater_out,
    output reg A_equal_out,
    output reg A_less_out
);

always @(*)
begin
    if (A_greater[2] == 1'b1) begin
        A_greater_out = 1'b1;
        A_equal_out = 1'b0;
        A_less_out = 1'b0;
    end else if (A_equal[2] == 1'b1) begin
        if (A_greater[1] == 1'b1) begin
            A_greater_out = 1'b1;
            A_equal_out = 1'b0;
            A_less_out = 1'b0;
        end else if (A_equal[1] == 1'b1) begin
            if (A_greater[0] == 1'b1) begin
                A_greater_out = 1'b1;
                A_equal_out = 1'b0;
                A_less_out = 1'b0;
            end else if (A_equal[0] == 1'b1) begin
                A_greater_out = 1'b0;
                A_equal_out = 1'b1;
                A_less_out = 1'b0;
            end else begin
                A_greater_out = 1'b0;
                A_equal_out = 1'b0;
                A_less_out = 1'b1;
            end
        end else begin
            A_greater_out = 1'b0;
            A_equal_out = 1'b0;
            A_less_out = 1'b1;
        end
    end else begin
        A_greater_out = 1'b0;
        A_equal_out = 1'b0;
        A_less_out = 1'b1;
    end
end

endmodule

// Instantiate bit-wise comparator and result combiner sub-modules
bit_comparator bit_comp_2(
   .A_bit(A[2]),
   .B_bit(B[2]),
   .A_greater(A_greater[2]),
   .A_equal(A_equal[2]),
   .A_less(A_less[2])
);

bit_comparator bit_comp_1(
   .A_bit(A[1]),
   .B_bit(B[1]),
   .A_greater(A_greater[1]),
   .A_equal(A_equal[1]),
   .A_less(A_less[1])
);

bit_comparator bit_comp_0(
   .A_bit(A[0]),
   .B_bit(B[0]),
   .A_greater(A_greater[0]),
   .A_equal(A_equal[0]),
   .A_less(A_less[0])
);

reg [2:0] A_greater_int;
reg [2:0] A_equal_int;
reg [2:0] A_less_int;

always @(*)
begin
    A_greater_int = {A_greater[2], A_greater[1], A_greater[0]};
    A_equal_int = {A_equal[2], A_equal[1], A_equal[0]};
    A_less_int = {A_less[2], A_less[1], A_less[0]};
end

result_combiner result_comb(
   .A_greater(A_greater_int),
   .A_equal(A_equal_int),
   .A_less(A_less_int),
   .A_greater_out(A_greater),
   .A_equal_out(A_equal),
   .A_less_out(A_less)
);

endmodule