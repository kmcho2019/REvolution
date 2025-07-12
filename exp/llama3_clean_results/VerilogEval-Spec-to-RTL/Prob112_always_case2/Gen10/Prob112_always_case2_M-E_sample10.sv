module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

integer i;

always @(*) begin
    pos = 2'b00; // Default to 0 if no '1' bits are found
    for (i = 3; i >= 0; i = i - 1) begin
        if (in[i] == 1'b1) begin // Check each bit from MSB to LSB
            case (i)
                3: pos = 2'b11; // MSB is the 4th position
                2: pos = 2'b10; // Second MSB is the 3rd position
                1: pos = 2'b01; // Second LSB is the 2nd position
                0: pos = 2'b00; // LSB is the 1st position
            endcase
            break; // Exit the loop once the first '1' bit is found
        end
    end
end

endmodule