module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    casez(in)
        4'b1???: pos = 2'b11;  // in[3] is high
        4'b01??: pos = 2'b10;   // in[2] is high
        4'b001?: pos = 2'b01;    // in[1] is high
        4'b0001: pos = 2'b00;    // in[0] is high
        default: pos = 2'b00;    // all zeros
    endcase
end

endmodule