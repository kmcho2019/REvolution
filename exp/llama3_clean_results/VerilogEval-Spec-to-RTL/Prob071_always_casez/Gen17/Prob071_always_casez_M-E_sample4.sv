module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    reg [2:0] pos_reg;
    reg [7:0] in_reg;

    always @(*) begin
        pos_reg = 3'd0;
        in_reg = in;
        for (int i = 0; i < 8; i++) begin
            if (in_reg[i]) begin
                pos_reg = $clog2(i+1);
                break;
            end
        end
    end

    assign pos = pos_reg;

endmodule