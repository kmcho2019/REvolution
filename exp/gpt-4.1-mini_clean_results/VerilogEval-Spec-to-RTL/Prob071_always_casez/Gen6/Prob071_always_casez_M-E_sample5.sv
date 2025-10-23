module TopModule(
    input  [7:0] in,
    output reg [2:0] pos
);
    integer i;
    reg found;
    reg [2:0] first_pos;

    always @(*) begin
        first_pos = 3'd0;
        found = 1'b0;
        for (i = 0; i < 8; i = i + 1) begin
            if (~found && in[i]) begin
                first_pos = i[2:0];
                found = 1'b1;
            end
        end
        pos = first_pos;
    end
endmodule