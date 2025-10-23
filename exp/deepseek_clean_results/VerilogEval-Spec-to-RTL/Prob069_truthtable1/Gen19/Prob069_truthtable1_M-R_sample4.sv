module TopModule (
    input x3,
    input x2,
    input x1,
    output reg f
);
    always @(*) begin
        case (x3)
            1'b0: f = x2;
            1'b1: f = x1;
        endcase
    end
endmodule