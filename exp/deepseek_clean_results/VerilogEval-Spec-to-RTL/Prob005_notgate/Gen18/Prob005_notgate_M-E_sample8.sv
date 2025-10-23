module TopModule (
    input in,
    output out
);
    // Implement NOT using a 2:1 MUX
    assign out = in ? 1'b0 : 1'b1;
endmodule