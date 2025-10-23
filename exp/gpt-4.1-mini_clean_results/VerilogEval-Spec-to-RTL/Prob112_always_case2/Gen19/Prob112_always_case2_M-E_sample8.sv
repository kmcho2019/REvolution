module TopModule (
    input  [3:0] in,
    output reg [1:0] pos
);
    integer i;
    always @(*) begin
        pos = 2'd0; // default output if no bit is set
        for (i = 0; i < 4; i = i + 1) begin
            if (in[i]) begin
                pos = i[1:0];
                disable for; // break out of loop after first match
            end
        end
    end
endmodule