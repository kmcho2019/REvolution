module TopModule(
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output reg [3:0] q
);

    always @(*) begin
        case (c[1:0])
            2'd0: q = (c == 4'd0) ? b : (c == 4'd1) ? e : (c == 4'd2) ? a : d;
            default: q = 4'd15; // This could potentially be optimized if 'c' is guaranteed to be within a certain range
        endcase
    end

endmodule