module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

    always @(*) begin
        pos = 3'd0;
        for (int i = 0; i < 8; i++) begin
            if (in[i]) begin
                pos = i + 1'd1;
                break;
            end
        end
    end

endmodule