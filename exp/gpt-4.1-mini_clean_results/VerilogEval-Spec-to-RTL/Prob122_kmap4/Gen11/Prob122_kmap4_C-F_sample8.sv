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

    // Drive output continuously from the internal reg
    assign out = parity;

endmodule