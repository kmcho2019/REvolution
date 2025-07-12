// Given the efficiency of the original solution, the following code remains largely the same.
// The focus shifts to ensuring the module is used optimally within its larger design context.
module TopModule(
    input x,
    input y,
    output logic z
);
    assign z = ~(x ^ y); // This remains the most efficient and straightforward implementation.
endmodule