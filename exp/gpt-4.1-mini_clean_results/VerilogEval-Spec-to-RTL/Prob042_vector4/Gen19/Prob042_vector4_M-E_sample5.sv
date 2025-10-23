module TopModule (
    input  [7:0] in,
    output reg [31:0] out
);

    reg signed [7:0] signed_in;
    reg signed [31:0] signed_out;

    always @(*) begin
        signed_in = in;
        signed_out = signed_in;  // Implicit sign-extension from 8-bit to 32-bit
        out = signed_out;
    end

endmodule