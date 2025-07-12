module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

    reg [2:0] pos_reg;
    reg found;

    always @(*) begin
        pos_reg = 3'd0;
        found = 1'b0;
        for (int i = 0; i < 8; i++) begin
            if (in[i] &&!found) begin
                pos_reg = i;
                found = 1'b1;
            end
        end
        pos = pos_reg;
    end

endmodule