module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Combined assignments for cleaner structure
    assign {cout, sum} = {
        (a & b) | ((a ^ b) & cin),  // cout calculation
        a ^ b ^ cin                 // sum calculation
    };
endmodule