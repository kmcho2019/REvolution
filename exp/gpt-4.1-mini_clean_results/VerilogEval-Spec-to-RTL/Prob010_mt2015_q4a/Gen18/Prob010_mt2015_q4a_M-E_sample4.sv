module XOR2 (
    input  a,
    input  b,
    output y
);
    assign y = a ^ b;
endmodule

module AND2 (
    input  a,
    input  b,
    output y
);
    assign y = a & b;
endmodule

module TopModule (
    input  x,
    input  y,
    output z
);
    wire xor_out;

    // Instantiate XOR2 for the xor operation
    XOR2 xor_inst (
        .a(x),
        .b(y),
        .y(xor_out)
    );

    // Instantiate AND2 for the and operation
    AND2 and_inst (
        .a(xor_out),
        .b(x),
        .y(z)
    );
endmodule