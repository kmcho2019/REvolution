module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    pos = 2'b00; // Default to 0 if no '1' bits are found
    if (in[3]) pos = 2'b11; // 3
    else if (in[2]) pos = 2'b10; // 2
    else if (in[1]) pos = 2'b01; // 1
    else if (in[0]) pos = 2'b00; // Corrected encoding for position 0
end

endmodule