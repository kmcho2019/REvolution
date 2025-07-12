module TopModule (
    input  [7:0] in,
    output reg [2:0] pos
);

always @(*) begin
    pos = 3'd0;
    for (int i = 0; i < 8; i = i + 1) begin
        if (in[i]) begin
            pos = i;
            disable for; // exit loop once first set bit found
        end
    end
end

endmodule