module TopModule(
    input [3:0] in,
    output reg [1:0] pos
);

    always @(*) begin
        pos = 2'b00; // Initialize pos to 0
        for (int i = 3; i >= 0; i--) begin
            if (in[i]) begin // Check each bit from MSB to LSB
                pos = i; // If '1' is found, assign its position to pos
                break; // Exit the loop once the first '1' is found
            end
        end
    end

endmodule