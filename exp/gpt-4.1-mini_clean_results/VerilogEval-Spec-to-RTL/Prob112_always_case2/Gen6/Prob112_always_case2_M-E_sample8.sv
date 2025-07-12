module TopModule (
    input  [3:0] in,
    output reg [1:0] pos
);
    always @(*) begin
        casez (in)
            4'b1zzz: pos = 2'd0; // bit 0 is first high
            4'b01zz: pos = 2'd1; // bit 1 is first high
            4'b001z: pos = 2'd2; // bit 2 is first high
            4'b0001: pos = 2'd3; // bit 3 is first high
            default: pos = 2'd0; // no bits set
        endcase
    end
endmodule