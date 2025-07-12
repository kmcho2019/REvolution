module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    if (in == 4'b0000) begin
        pos = 2'b00;  // Explicit zero case
    end
    else if (in[0]) begin
        pos = 2'b00;  // Bit 0 is 1
    end
    else if (in[1]) begin
        pos = 2'b01;  // Bit 1 is 1
    end
    else if (in[2]) begin
        pos = 2'b10;  // Bit 2 is 1
    end
    else begin
        pos = 2'b11;  // Bit 3 is 1
    end
end

endmodule