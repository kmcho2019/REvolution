module TopModule (
    input a,
    input b,
    input c,
    output w,
    output x,
    output y,
    output z
);
    // Encoding inputs into a 2-bit signal
    wire [1:0] encoded;
    assign encoded = {b, a};  // Only need 2 bits for our connections
    
    // Decoding to outputs
    assign w = encoded[0];    // a is LSB
    assign x = encoded[1];    // b is MSB
    assign y = encoded[1];    // b is MSB
    assign z = c;             // c is passed through directly
endmodule