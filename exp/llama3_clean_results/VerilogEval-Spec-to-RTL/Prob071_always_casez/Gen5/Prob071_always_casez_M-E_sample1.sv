module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    reg [2:0] counter;
    reg [2:0] pos_reg;

    always @(*) begin
        counter = 3'd0;
        pos_reg = 3'd0;

        for (int i = 0; i < 8; i++) begin
            if (in[i]) begin
                counter = 3'di;
                pos_reg = counter;
                break;
            end
        end
    end

    assign pos = (in == 8'd0) ? 3'd0 : pos_reg;

endmodule