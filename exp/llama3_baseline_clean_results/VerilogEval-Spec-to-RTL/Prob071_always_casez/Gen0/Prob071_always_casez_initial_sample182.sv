module TopModule(
    input [7:0] in,  // 8-bit input
    output [2:0] pos  // 3-bit output
);

always @(*) begin
    pos = 3'd0;  // default output
    for (int i = 0; i < 8; i++) begin
        if (in[i] == 1'b1) begin
            pos = i;  // output position of first high bit
            break;  // stop searching once first high bit is found
        end
    end
end

endmodule