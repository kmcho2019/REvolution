module TopModule(
    input [2:0] in,
    output [1:0] out
);

    reg [1:0] out_reg;

    always @(*)
    begin
        // Directly compute the population count using logic operations
        out_reg[0] = in[0] ^ in[1] ^ in[2];
        out_reg[1] = (in[0] & in[1]) | (in[0] & in[2]) | (in[1] & in[2]);
        out = out_reg;
    end

endmodule