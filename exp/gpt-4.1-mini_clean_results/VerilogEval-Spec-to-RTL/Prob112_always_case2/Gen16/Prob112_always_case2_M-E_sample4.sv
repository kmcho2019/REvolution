module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

integer i;
always @* begin
    pos = 2'd0;
    for (i = 0; i < 4; i = i + 1) begin
        if (in[i]) begin
            pos = i[1:0];
            disable for;
        end
    end
end

endmodule