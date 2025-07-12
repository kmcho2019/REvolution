module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    always @(*) begin
        pos = 3'd0;
        for (int i = 7; i >= 0; i--) begin
            if (in[i] == 1'b1) begin
                pos = 3'di;
                break;
            end
        end
    end

endmodule