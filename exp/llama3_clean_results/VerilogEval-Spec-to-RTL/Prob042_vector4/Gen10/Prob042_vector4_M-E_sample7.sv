module TopModule (
    input [7:0] in,
    output [31:0] out
);

    reg [23:0] sign_bits;

    always @(*) begin
        if (in[7] == 1'b1) begin
            sign_bits = 24'b1;
        end else begin
            sign_bits = 24'b0;
        end
        out = {sign_bits, in};
    end

endmodule