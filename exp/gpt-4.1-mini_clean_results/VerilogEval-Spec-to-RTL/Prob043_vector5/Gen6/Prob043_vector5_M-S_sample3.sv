module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] inputs = {a, b, c, d, e};
    
    assign out = {
        ~(inputs[4] ^ inputs[4]), ~(inputs[4] ^ inputs[3]), ~(inputs[4] ^ inputs[2]), ~(inputs[4] ^ inputs[1]), ~(inputs[4] ^ inputs[0]),
        ~(inputs[3] ^ inputs[4]), ~(inputs[3] ^ inputs[3]), ~(inputs[3] ^ inputs[2]), ~(inputs[3] ^ inputs[1]), ~(inputs[3] ^ inputs[0]),
        ~(inputs[2] ^ inputs[4]), ~(inputs[2] ^ inputs[3]), ~(inputs[2] ^ inputs[2]), ~(inputs[2] ^ inputs[1]), ~(inputs[2] ^ inputs[0]),
        ~(inputs[1] ^ inputs[4]), ~(inputs[1] ^ inputs[3]), ~(inputs[1] ^ inputs[2]), ~(inputs[1] ^ inputs[1]), ~(inputs[1] ^ inputs[0]),
        ~(inputs[0] ^ inputs[4]), ~(inputs[0] ^ inputs[3]), ~(inputs[0] ^ inputs[2]), ~(inputs[0] ^ inputs[1]), ~(inputs[0] ^ inputs[0])
    };
endmodule