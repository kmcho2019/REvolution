module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

always @(*) begin
    pos = 2'b00; // default output is 0
    if (in[3] == 1'b1) pos = 2'b10; // bit 3 is most significant
    else if (in[2] == 1'b1) pos = 2'b01;
    else if (in[1] == 1'b1) pos = 2'b00; // corrected to 2'b00 for 0-indexed position 1
    else if (in[0] == 1'b1) pos = 2'b11; // corrected to 2'b11 for 0-indexed position 3
end

endmodule