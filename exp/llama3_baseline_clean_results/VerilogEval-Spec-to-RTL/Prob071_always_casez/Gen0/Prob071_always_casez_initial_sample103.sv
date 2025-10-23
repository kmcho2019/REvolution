module TopModule(
    input [7:0] in,
    output [2:0] pos
    );

    always @(in) begin
        pos = 3'd0;
        for (int i = 0; i < 8; i++) begin
            if (in[i] == 1'b1) begin
                pos = 3'd(i);
                break;
            end
        end
    end

endmodule