module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    // Combine inputs into a vector
    wire [2:0] in_vec;
    assign in_vec = {c, b, a}; // [2]=c, [1]=b, [0]=a

    // Define output vector
    wire [3:0] out_vec;

    // Map outputs from input vector bits
    assign out_vec[0] = in_vec[0]; // w = a
    assign out_vec[1] = in_vec[1]; // x = b
    assign out_vec[2] = in_vec[1]; // y = b
    assign out_vec[3] = in_vec[2]; // z = c

    // Connect outputs to vector bits
    assign {z, y, x, w} = out_vec;
endmodule