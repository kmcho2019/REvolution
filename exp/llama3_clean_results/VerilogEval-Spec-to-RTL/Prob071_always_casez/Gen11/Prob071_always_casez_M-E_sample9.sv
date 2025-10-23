module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

    reg [2:0] pos_reg;
    integer i;

    always @(*) begin
        pos_reg = 3'd0;
        for (i = 0; i < 8; i++) begin
            if (in[i]) begin
                pos_reg = i;
                break;
            end
        end
        pos = pos_reg;
    end

endmodule