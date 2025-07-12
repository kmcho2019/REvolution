module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

    integer i;
    reg [2:0] pos_reg;

    always @(*) begin
        pos_reg = 3'd0; // Initialize output to 0
        for (i = 0; i < 8; i = i + 1) begin
            if (in[i] == 1'b1) begin
                pos_reg = i; // Output position of first high bit
                break;
            end
        end
        pos = pos_reg;
    end

endmodule