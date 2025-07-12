module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    reg parity;

    // Compute parity (XOR of all inputs) in a combinational always block
    always @(*) begin
        parity = a ^ b ^ c ^ d;
    end

    // Assign internal reg to output
    assign out = parity;

endmodule