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

    // Define a vector of inputs for systematic instantiation
    wire [4:0] inputs;
    assign inputs[0] = a;
    assign inputs[1] = b;
    assign inputs[2] = c;
    assign inputs[3] = d;
    assign inputs[4] = e;

    // Instantiate the comparator module for each comparison
    genvar i, j;
    generate
        for (i = 0; i < 5; i++) begin
            for (j = 0; j < 5; j++) begin
                Comparator cmp(out[i*5 + j], inputs[i], inputs[j]);
            end
        end
    endgenerate

endmodule