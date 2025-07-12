module TopModule(
    input  [7:0] in,
    output reg   parity
);
    integer i;
    reg temp_parity;

    always @(*) begin
        temp_parity = 1'b0;
        for (i = 0; i < 8; i = i + 1) begin
            temp_parity = temp_parity ^ in[i];
        end
        parity = temp_parity;
    end
endmodule