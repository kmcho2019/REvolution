module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);

    wire buf_w;
    wire buf_x;
    wire buf_y;
    wire buf_z;

    // Buffer connections
    assign buf_w = a;
    assign buf_x = b;
    assign buf_y = b;
    assign buf_z = c;

    // Outputs driven by buffered wires
    assign w = buf_w;
    assign x = buf_x;
    assign y = buf_y;
    assign z = buf_z;

endmodule