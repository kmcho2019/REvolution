module TopModule (
    input  [3:0] in,
    output reg [1:0] pos
);

    always @(*) begin
        casex (in)
            4'b1xxx: pos = 2'd3; // highest priority bit 3
            4'b01xx: pos = 2'd2; // then bit 2
            4'b001x: pos = 2'd1; // then bit 1
            4'b0001: pos = 2'd0; // then bit 0
            default: pos = 2'd0; // no bit set
        endcase
    end

endmodule