module TopModule(x, y, z);
    input x, y;
    output z;
    wire or_out, and_out;

    // Directly calculate the outputs of the OR and AND gates
    // Module A's simplified logic: x & (!y)
    // Module B's logic: (!x & !y) | (x & y)
    assign or_out = ((x & (!y)) | ((x & y) | (!x & !y)));
    assign and_out = ((x & (!y)) & ((x & y) | (!x & !y)));

    // Final XOR operation to produce output 'z'
    assign z = or_out ^ and_out;
endmodule