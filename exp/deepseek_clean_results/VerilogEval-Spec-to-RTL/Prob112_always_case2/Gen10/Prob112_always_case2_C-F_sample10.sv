module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    if (in == 4'b0000) begin
        pos = 2'b00;  // Explicit zero case for power optimization
    end else begin
        case (in & -in)  // Efficient rightmost 1-bit isolation
            4'b0001: pos = 2'b00;
            4'b0010: pos = 2'b01;
            4'b0100: pos = 2'b10;
            4'b1000: pos = 2'b11;
        endcase
    end
end

endmodule