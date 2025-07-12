module TopModule(
    input [3:0] in,
    output reg [1:0] pos
);

    always @(*) begin
        pos = 2'b00; // Default output
        if (in[3] == 1'b1) pos = 2'b11; // Check MSB
        else if (in[2] == 1'b1) pos = 2'b10; // Check second MSB
        else if (in[1] == 1'b1) pos = 2'b01; // Check second LSB
        // If none of the above conditions are met, and in[0] is 1, pos remains 2'b00
    end

endmodule