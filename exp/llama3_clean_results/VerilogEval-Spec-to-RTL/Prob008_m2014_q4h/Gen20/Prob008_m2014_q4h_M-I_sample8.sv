// Improved Solution: Direct Assignment with Buf Primitive
module TopModule(
    input  logic in,  // Input port
    output logic out  // Output port
);
    // Direct assignment with Buf primitive for reduced power consumption and area usage
    logic buf_out;
    buf buf_out(in, buf_out);
    assign out = buf_out;
endmodule