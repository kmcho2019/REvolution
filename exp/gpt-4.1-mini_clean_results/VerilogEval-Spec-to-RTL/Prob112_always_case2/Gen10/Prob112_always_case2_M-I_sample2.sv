module TopModule (
    input  [3:0] in,
    output reg [1:0] pos
);

    always @(*) begin
        casex (in)
            4'b0001: pos = 2'd0;
            4'b001?: pos = 2'd1;  // matches 0010 or 0011
            4'b01??: pos = 2'd2;  // matches 0100 to 0111
            4'b1???: pos = 2'd3;  // matches 1000 to 1111
            default: pos = 2'd0;  // no bits set
        endcase
    end

endmodule