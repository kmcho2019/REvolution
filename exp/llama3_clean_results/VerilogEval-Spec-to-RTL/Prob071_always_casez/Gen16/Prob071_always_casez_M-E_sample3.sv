module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    reg [2:0] pos_reg;
    integer i;

    always @(*) begin
        pos_reg = 3'd0;
        for (i = 0; i < 8; i = i + 1) begin
            if (in[i] == 1'b1) begin
                pos_reg = i;
                break;
            end
        end
    end

    assign pos = pos_reg;

endmodule