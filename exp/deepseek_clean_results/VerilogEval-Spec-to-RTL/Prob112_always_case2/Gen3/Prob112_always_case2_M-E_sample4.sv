module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

    always @(*) begin
        if (in[3])       pos = 2'b11;  // Highest priority - bit 3
        else if (in[2])  pos = 2'b10;  // Next priority - bit 2
        else if (in[1])  pos = 2'b01;  // Next priority - bit 1
        else if (in[0])  pos = 2'b00;  // Lowest priority - bit 0
        else             pos = 2'b00;  // No bits set
    end

endmodule