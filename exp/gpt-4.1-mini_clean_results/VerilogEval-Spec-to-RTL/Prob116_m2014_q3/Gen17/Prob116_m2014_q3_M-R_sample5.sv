module TopModule (
    input  [3:0] x, // x[3] = x4, x[2] = x3, x[1] = x2, x[0] = x1 (problem notation)
    output reg    f
);

    always @(*) begin
        case (x)
            4'b1100, // x3=1,x4=1,x1=0,x2=0
            4'b1101, // x3=1,x4=1,x1=0,x2=1
            4'b1000, // x3=1,x4=0,x1=0,x2=0
            4'b1001, // x3=1,x4=0,x1=0,x2=1
            4'b0111: // x3=0,x4=1,x1=1,x2=1
                f = 1'b1;
            default:
                f = 1'b0;
        endcase
    end

endmodule