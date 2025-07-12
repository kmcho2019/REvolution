module TopModule(
    input [3:0] x,
    output reg f
);

always @(*) begin
    case ({x[3], x[2], x[1]})
        // When x[3] is high, f is high regardless of x[2] and x[1].
        3'b1?? : f = 1'b1;
        // When x[3] is low, x[2] and x[1] must both be high for f to be high.
        3'b011 : f = 1'b1;
        default : f = 1'b0;
    endcase
end

endmodule