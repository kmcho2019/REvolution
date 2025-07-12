// Define a small, reusable comparator module
module Comparator(
    input  a,
    input  b,
    output out
);
    assign out = ~(a ^ b);
endmodule

// TopModule utilizing the Comparator module and generate statement
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    // Define input array
    wire [4:0] inputs = {a, b, c, d, e};

    // Instantiate comparator modules using a generate loop
    genvar i, j;
    generate
        for (i = 0; i < 5; i++) begin
            for (j = i; j < 5; j++) begin
                if (i == j) begin
                    assign out[(i*5)+j] = 1'b1; // Comparison with itself always results in 1
                end else begin
                    Comparator cmp(inputs[i], inputs[j], out[(i*5)+j]);
                    // Mirror the result for the lower triangular part
                    assign out[(j*5)+i] = out[(i*5)+j];
                end
            end
        end
    endgenerate

endmodule