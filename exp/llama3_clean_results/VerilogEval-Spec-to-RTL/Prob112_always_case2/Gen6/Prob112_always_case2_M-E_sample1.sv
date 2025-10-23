module TopModule(
    input [3:0] in,
    output reg [1:0] pos
);

    always @(*) begin
        casez (in)
            4'b1000: pos = 2'b11; // bit 3
            4'b0100: pos = 2'b10; // bit 2
            4'b0010: pos = 2'b01; // bit 1
            4'b0001: pos = 2'b00; // bit 0
            default: pos = 2'b00; // default to 0 if no '1' bits are found
        endcase
    end

endmodule