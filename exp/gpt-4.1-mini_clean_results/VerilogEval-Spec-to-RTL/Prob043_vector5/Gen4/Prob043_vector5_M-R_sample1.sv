module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [0:4] inputs;
    assign inputs[0] = a;
    assign inputs[1] = b;
    assign inputs[2] = c;
    assign inputs[3] = d;
    assign inputs[4] = e;

    genvar k;
    generate
        for (k = 0; k < 25; k = k + 1) begin : cmp_loop
            // Calculate i and j for given k
            localparam integer idx = 24 - k;
            localparam integer i = idx / 5;
            localparam integer j = idx % 5;

            // Assign output bit with XNOR of inputs[i] and inputs[j]
            assign out[k] = ~(inputs[i] ^ inputs[j]);
        end
    endgenerate
endmodule