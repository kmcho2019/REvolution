module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);
    // Pack inputs into an array for easy referencing
    wire [4:0] inputs = {a, b, c, d, e};
    
    // Compute all 25 pairwise equality bits explicitly from (a,a) to (e,e)
    assign out = {
        ~(inputs[0] ^ inputs[0]), ~(inputs[0] ^ inputs[1]), ~(inputs[0] ^ inputs[2]), ~(inputs[0] ^ inputs[3]), ~(inputs[0] ^ inputs[4]),
        ~(inputs[1] ^ inputs[0]), ~(inputs[1] ^ inputs[1]), ~(inputs[1] ^ inputs[2]), ~(inputs[1] ^ inputs[3]), ~(inputs[1] ^ inputs[4]),
        ~(inputs[2] ^ inputs[0]), ~(inputs[2] ^ inputs[1]), ~(inputs[2] ^ inputs[2]), ~(inputs[2] ^ inputs[3]), ~(inputs[2] ^ inputs[4]),
        ~(inputs[3] ^ inputs[0]), ~(inputs[3] ^ inputs[1]), ~(inputs[3] ^ inputs[2]), ~(inputs[3] ^ inputs[3]), ~(inputs[3] ^ inputs[4]),
        ~(inputs[4] ^ inputs[0]), ~(inputs[4] ^ inputs[1]), ~(inputs[4] ^ inputs[2]), ~(inputs[4] ^ inputs[3]), ~(inputs[4] ^ inputs[4])
    };
endmodule