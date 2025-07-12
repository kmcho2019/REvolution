module Buffer #(parameter ENABLE = 1) (
    input  wire in,
    output wire out
);
    // If ENABLE=1, buffer acts as a direct wire (assign). If 0, tie output to input directly.
    generate
        if (ENABLE) begin
            assign out = in;
        end else begin
            assign out = in;
        end
    endgenerate
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    output wire w,
    output wire x,
    output wire y,
    output wire z
);

    // Using buffer modules instantiated structurally to improve modular clarity
    Buffer buf_w (.in(a), .out(w));
    Buffer buf_x (.in(b), .out(x));
    Buffer buf_y (.in(b), .out(y));
    Buffer buf_z (.in(c), .out(z));

endmodule