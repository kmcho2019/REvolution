// Define a small, reusable comparator module
module Comparator(
    input  a,
    input  b,
    output out
);
    assign out = ~(a ^ b);
endmodule

// TopModule utilizing the Comparator module
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

    // Instantiate comparator modules using nested loops
    genvar i, j;
    generate
        for (i = 0; i < 5; i++) begin
            for (j = 0; j < 5; j++) begin
                Comparator cmp(inputs[i], inputs[j], out[(i*5)+j]);
            end
        end
    endgenerate

endmodule