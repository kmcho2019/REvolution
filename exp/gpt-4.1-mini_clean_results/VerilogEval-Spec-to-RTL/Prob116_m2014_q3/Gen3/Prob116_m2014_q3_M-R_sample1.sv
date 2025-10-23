module TopModule(
    input [3:0] x,
    output reg f
);

    always @(*) begin
        case (x)
            4'b0111: f = 1; // (~x3 & x2 & x1 & x0)
            4'b1100,
            4'b1101: f = 1; // (x3 & x2 & ~x1 & x0=0 or 1)
            4'b1000,
            4'b1001: f = 1; // (x3 & ~x2 & ~x1 & x0=0 or 1)
            default: f = 0;
        endcase
    end

endmodule