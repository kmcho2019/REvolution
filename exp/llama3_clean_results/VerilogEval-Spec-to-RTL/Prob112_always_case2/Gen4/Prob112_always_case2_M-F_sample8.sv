module TopModule(
    input [3:0] in,
    output reg [1:0] pos
);

    always @(*) begin
        pos = 2'b00; // Default output
        if (in[3]) pos = 2'b11; // Check MSB
        else if (in[2]) pos = 2'b10; // Check second MSB
        else if (in[1]) pos = 2'b01; // Check second LSB
        else if (in[0]) pos = 2'b00; // Check LSB
    end

endmodule