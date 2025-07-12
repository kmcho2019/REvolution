module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

always @(*) begin
    // Initialize pos to 0, assuming no '1' bits are found
    pos = 2'b00;

    // Check bits from most significant to least significant
    if (in[3]) pos = 2'b11; // Position of in[3] is 3
    else if (in[2]) pos = 2'b10; // Position of in[2] is 2
    else if (in[1]) pos = 2'b01; // Position of in[1] is 1
    else if (in[0]) pos = 2'b00; // Position of in[0] is 0
    // If none of the above conditions are met, pos remains 2'b00
end

endmodule