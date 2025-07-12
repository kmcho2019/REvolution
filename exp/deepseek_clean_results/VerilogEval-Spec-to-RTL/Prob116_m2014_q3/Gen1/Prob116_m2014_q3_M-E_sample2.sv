module TopModule(
    input [3:0] x,
    output reg f
);
    always @(*) begin
        case (x)
            4'b1100,  // x[3]x[0]=11, x[2]x[1]=00
            4'b1101,  // x[3]x[0]=11, x[2]x[1]=01
            4'b1000,  // x[3]x[0]=10, x[2]x[1]=00
            4'b1001,  // x[3]x[0]=10, x[2]x[1]=01
            4'b0111:  // x[3]x[0]=01, x[2]x[1]=11
                f = 1'b1;
            default:
                f = 1'b0;
        endcase
    end
endmodule