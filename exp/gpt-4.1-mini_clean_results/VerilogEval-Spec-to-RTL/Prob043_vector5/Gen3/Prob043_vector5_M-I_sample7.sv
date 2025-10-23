module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    localparam N = 5;
    wire [N-1:0] inputs = {a, b, c, d, e};  // inputs[4]=a (MSB) to inputs[0]=e (LSB)

    genvar idx;
    generate
        for (idx = 0; idx < N*N; idx = idx + 1) begin : gen_eq
            // Compute i,j from idx such that idx = i*5 + j
            localparam integer i = idx / N;
            localparam integer j = idx % N;

            // out[24 - idx] = 1 if inputs[i] == inputs[j]
            // Use == operator for equality; synthesis should optimize to XNOR
            assign out[24 - idx] = (inputs[N-1 - i] == inputs[N-1 - j]);
        end
    endgenerate
endmodule