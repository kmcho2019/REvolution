module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    // Initialize pos to 0
    pos = 2'b00;

    // Check each bit from MSB to LSB and update pos accordingly
    if (in[3]) begin
        pos = 2'b11;  // Most significant bit (position 3)
    end else if (in[2]) begin
        pos = 2'b10;  // Second most significant bit (position 2)
    end else if (in[1]) begin
        pos = 2'b01;  // Second least significant bit (position 1)
    end else if (in[0]) begin
        pos = 2'b00;  // Least significant bit (position 0)
    end
end

endmodule