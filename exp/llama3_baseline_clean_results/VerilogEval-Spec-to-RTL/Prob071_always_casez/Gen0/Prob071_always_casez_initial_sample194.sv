module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

always @(in) begin
    pos = 3'd0; // initialize pos to 0
    for (int i = 0; i < 8; i++) begin
        if (in[i] == 1'b1) begin
            pos = i + 1; // assign pos the position of the first high bit
            break; // exit the loop as soon as we find the first high bit
        end
    end
end

endmodule