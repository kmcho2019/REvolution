module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

// Combined mask generation and first '1' isolation
wire [3:0] first_one = in & ~(in - 1);

always @(*) begin
    case (first_one)
        4'b0001: pos = 2'b00;
        4'b0010: pos = 2'b01;
        4'b0100: pos = 2'b10;
        4'b1000: pos = 2'b11;
        default: pos = 2'b00;  // handles all-zero case
    endcase
end

endmodule