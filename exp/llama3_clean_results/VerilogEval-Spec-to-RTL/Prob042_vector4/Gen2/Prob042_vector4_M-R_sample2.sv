module TopModule(
    input  [7:0] in,
    output [31:0] out
);

    reg [23:0] sign_bit_repeated;

    always @(*) begin
        sign_bit_repeated = {24{in[7]}};
        out = {sign_bit_repeated, in};
    end

endmodule