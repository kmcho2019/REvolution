module TopModule (
    input a,
    input b,
    output sum,
    output cout
);
    // Combined approach: explicit operations with concatenated assignment
    assign {cout, sum} = {(a & b), (a ^ b)};
endmodule