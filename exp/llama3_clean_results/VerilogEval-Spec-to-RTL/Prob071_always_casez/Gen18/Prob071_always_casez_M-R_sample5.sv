module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    reg [2:0] pos_temp;
    always @(in) begin
        pos_temp = 3'd0;
        for (int i = 0; i < 8; i++) begin
            if (in[i]) begin
                pos_temp = i;
                break;
            end
        end
    end
    assign pos = pos_temp;

endmodule