module TopModule (
    input  [3:0] in,
    output reg [1:0] pos
);
    always @(*) begin
        casez (in)
            4'b0001: pos = 2'd0;
            4'b001?: pos = 2'd1; // bit1 set (bit0 cleared or don't care)
            4'b01??: pos = 2'd2; // bit2 set
            4'b1???: pos = 2'd3; // bit3 set
            default: pos = 2'd0; // no bits set
        endcase
    end
endmodule