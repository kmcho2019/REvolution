module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

reg [2:0] pos_reg;
reg [7:0] in_reg;

always @(in) begin
    pos_reg = 3'd0;
    in_reg = in;
    for (int i = 0; i < 8; i++) begin
        if (in_reg[0]) begin
            pos_reg = i;
            break;
        end
        in_reg = in_reg >> 1;
    end
end

assign pos = pos_reg;

endmodule