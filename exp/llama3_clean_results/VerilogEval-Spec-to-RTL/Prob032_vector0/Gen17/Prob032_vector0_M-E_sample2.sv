module TopModule(
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
    );

    reg [2:0] shift_reg;

    always @(*) begin
        shift_reg = vec;
        outv = vec;
        o2 = shift_reg[2];
        o1 = shift_reg[1];
        o0 = shift_reg[0];
    end

endmodule