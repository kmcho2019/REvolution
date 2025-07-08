module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    assign out = {
        {a^~a, a^~b, a^~c, a^~d, a^~e}, // out[24:20]
        {b^~a, b^~b, b^~c, b^~d, b^~e}, // out[19:15]
        {c^~a, c^~b, c^~c, c^~d, c^~e}, // out[14:10]
        {d^~a, d^~b, d^~c, d^~d, d^~e}, // out[9:5]
        {e^~a, e^~b, e^~c, e^~d, e^~e}  // out[4:0]
    };

endmodule