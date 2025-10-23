module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos  // 3-bit output
);

    always @(*) begin
        pos = 3'b000;
        for (int i = 0; i < 8; i++) begin
            if (in[i]) begin
                pos = i;
                break;
            end
        end
    end

endmodule