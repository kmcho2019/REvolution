module TopModule(
    input  [7:0] in,
    output reg [2:0] pos
);
    integer i;
    always @(*) begin
        pos = 3'd0; // default output if no bits set
        for (i = 0; i < 8; i = i + 1) begin
            if (in[i]) begin
                pos = i[2:0];
                disable for;  // stop at first set bit
            end
        end
    end
endmodule