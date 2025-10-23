module TopModule(
    input [3:0] in,
    output [1:0] pos
);

always @(*) begin
    pos = 2'b00; // Default output to 0
    if (in[3] == 1'b1) begin
        pos = 2'b11; // Position 3
    end else if (in[2] == 1'b1) begin
        pos = 2'b10; // Position 2
    end else if (in[1] == 1'b1) begin
        pos = 2'b01; // Position 1
    end else if (in[0] == 1'b1) begin
        pos = 2'b00; // Position 0
    end
end

endmodule