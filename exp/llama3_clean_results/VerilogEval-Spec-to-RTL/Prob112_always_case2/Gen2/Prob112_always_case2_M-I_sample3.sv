module TopModule(
    input [3:0] in,
    output reg [1:0] pos
);

    always @(*) begin
        if (in[3]) // Most significant bit is 1
            pos = 2'b11;
        else if (in[2]) // Second most significant bit is 1
            pos = 2'b10;
        else if (in[1]) // Third most significant bit is 1
            pos = 2'b01;
        else if (in[0]) // Least significant bit is 1
            pos = 2'b00;
        else // No 1 bit found
            pos = 2'b00;
    end

endmodule