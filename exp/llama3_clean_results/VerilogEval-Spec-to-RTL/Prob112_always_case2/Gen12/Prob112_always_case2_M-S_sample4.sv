module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    pos = 2'b00; // Default output to 0
    for (int i = 3; i >= 0; i--) begin
        if (in[i] == 1'b1) begin
            case (i)
                3: pos = 2'b11; // MSB
                2: pos = 2'b10; // Second MSB
                1: pos = 2'b01; // Second LSB
                0: pos = 2'b10; // LSB
            endcase
            break; // Stop searching once the first '1' bit is found
        end
    end
end

endmodule