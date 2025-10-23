module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    pos = 2'b00; // Default output to 0 if no '1' bits are found
    if (in[3] == 1'b1) pos = 2'b11; // Check MSB
    else if (in[2] == 1'b1) pos = 2'b10; // Check second MSB
    else if (in[1] == 1'b1) pos = 2'b01; // Check second LSB
    // No need to explicitly check LSB, as it will be handled by the default assignment of pos
end

endmodule