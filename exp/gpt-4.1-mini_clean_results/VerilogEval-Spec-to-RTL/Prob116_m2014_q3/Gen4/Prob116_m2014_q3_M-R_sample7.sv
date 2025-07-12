module TopModule(
    input  [3:0] x,
    output reg  f
);
    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    always @(*) begin
        case (x)
            // (x3,x2,x1,x0)
            // Ones from Karnaugh map based on simplified logic:
            4'b0111, // ~x3 & x0 & x1 & x2
            4'b1000, // x3 & ~x1 & ~x2 & ~x0 (covered by second term)
            4'b1001,
            4'b1100,
            4'b1101: f = 1'b1;
            default: f = 1'b0;
        endcase
    end

endmodule