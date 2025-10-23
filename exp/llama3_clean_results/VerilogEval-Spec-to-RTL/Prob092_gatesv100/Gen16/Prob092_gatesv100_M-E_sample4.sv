module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    reg [99:0] shift_reg;

    always @(*) begin
        shift_reg = in;
        for (int i = 0; i < 100; i++) begin
            out_both[i] = (i < 99) ? in[i] & shift_reg[i+1] : 1'b0;
            out_any[i]  = (i > 0) ? in[i] | shift_reg[i-1] : 1'b0;
            out_different[i] = in[i] ^ shift_reg[(i+1) % 100];
        end
    end

endmodule