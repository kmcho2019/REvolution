module TopModule(
    input  [99:0] in,
    output [99:0] out
);

    reg [99:0] shift_reg;
    reg [99:0] temp_out;

    always @(*) begin
        temp_out = 0;
        shift_reg = in;
        for (int i = 0; i < 100; i++) begin
            temp_out[i] = shift_reg[99 - i];
        end
        out = temp_out;
    end

endmodule