module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    pos = 2'b00; // Default: If no '1' bits are found, output is 0
    if (in[3] == 1'b1) begin // Check MSB first
        pos = 2'b11; // MSB is the 4th position
    end else if (in[2] == 1'b1) begin
        pos = 2'b10; // Second MSB is the 3rd position
    end else if (in[1] == 1'b1) begin
        pos = 2'b01; // Second LSB is the 2nd position
    end else if (in[0] == 1'b1) begin
        pos = 2'b00; // LSB is the 1st position
    end
end

endmodule