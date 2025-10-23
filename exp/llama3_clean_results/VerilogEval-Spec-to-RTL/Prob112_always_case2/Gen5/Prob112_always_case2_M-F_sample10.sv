module TopModule(
    input [3:0] in,
    output reg [1:0] pos
);

    always @(*) begin
        if (in[3]) pos = 2'b11; // bit 3
        else if (in[2]) pos = 2'b10; // bit 2
        else if (in[1]) pos = 2'b01; // bit 1
        else if (in[0]) pos = 2'b00; // bit 0
        else pos = 2'b00; // default to 0 if no '1' bits are found
    end

endmodule