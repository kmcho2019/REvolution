module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

reg [2:0] pos_reg;
integer i;

always @(*) begin
    pos_reg = 3'd0; // Initialize pos_reg to 0
    for (i = 0; i < 8; i = i + 1) begin
        if (in[i] == 1'b1) begin
            pos_reg = i; // Assign the position of the first '1' bit to pos_reg
            break; // Exit the loop once the first '1' bit is found
        end
    end
    pos = pos_reg; // Assign pos_reg to the output pos
end

endmodule