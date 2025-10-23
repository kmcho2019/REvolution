module TopModule(
    input [7:0] in,
    output [2:0] pos
);

    integer i;

    always @(*) begin
        pos = 0;
        for (i = 0; i < 8; i = i + 1) begin
            if (in[i] == 1'b1) begin
                pos = i;
                break;
            end
        end
    end

endmodule