module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    casez(in)
        4'b1???: pos = 2'b11;  // in[3] is highest priority
        4'b01??: pos = 2'b10;   // then in[2]
        4'b001?: pos = 2'b01;   // then in[1]
        4'b0001: pos = 2'b00;   // then in[0]
        default: pos = 2'b00;   // all zeros case
    endcase
end

endmodule