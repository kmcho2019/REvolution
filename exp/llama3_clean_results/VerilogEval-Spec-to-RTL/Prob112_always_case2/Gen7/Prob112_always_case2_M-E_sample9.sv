module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    pos = 2'b00; // Default to 0 if no '1' bits are found
    for (int i = 3; i >= 0; i--) begin
        if (in[i] == 1'b1) begin
            // Calculate the position by adding 1 to the index and convert to binary
            case (i)
                3: pos = 2'b11; // Position 4
                2: pos = 2'b10; // Position 3
                1: pos = 2'b01; // Position 2
                0: pos = 2'b00; // Position 1, but could be considered as default for no '1' bits found
            endcase
            break; // Exit the loop once the first '1' bit is found
        end
    end
end

endmodule