module TopModule (
    input  [7:0] in,
    output reg    parity
);
    integer i;
    reg xor_accum;

    always @(*) begin
        xor_accum = 0;
        for (i = 0; i < 8; i = i + 1) begin
            xor_accum = xor_accum ^ in[i];
        end
        parity = xor_accum;
    end
endmodule