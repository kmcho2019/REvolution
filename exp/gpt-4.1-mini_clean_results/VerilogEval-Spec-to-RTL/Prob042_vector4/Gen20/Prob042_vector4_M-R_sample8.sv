module TopModule (
    input  [7:0] in,
    output reg [31:0] out
);

    always @(*) begin
        // Interpret 'in' as signed 8-bit and assign to signed 32-bit variable 'signed_ext'
        // This automatically performs sign extension.
        // Then assign 'signed_ext' back to unsigned 'out' to produce the sign-extended output.
        reg signed [7:0] signed_in;
        reg signed [31:0] signed_ext;

        signed_in = in;
        signed_ext = signed_in;
        out = signed_ext;
    end

endmodule