module TopModule (
    input  [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    casez (in)
        4'b1???: pos = 2'd3; // bit 3 set
        4'b01??: pos = 2'd2; // bit 2 set
        4'b001?: pos = 2'd1; // bit 1 set
        4'b0001: pos = 2'd0; // bit 0 set
        default: pos = 2'd0; // no bits set
    endcase
end

endmodule