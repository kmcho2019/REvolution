module TopModule(
    input [3:0] x,
    output reg f
);
    always @(*) begin
        case (x)
            4'b0000: f = 1'b1;  // x[3:2]=00, x[1:0]=00
            4'b0010: f = 1'b1;  // x[3:2]=00, x[1:0]=10
            4'b1100: f = 1'b1;  // x[3:2]=11, x[1:0]=00
            4'b1101: f = 1'b1;  // x[3:2]=11, x[1:0]=01
            4'b1111: f = 1'b1;  // x[3:2]=11, x[1:0]=11
            4'b1000: f = 1'b1;  // x[3:2]=10, x[1:0]=00
            4'b1001: f = 1'b1;  // x[3:2]=10, x[1:0]=01
            4'b1010: f = 1'b1;  // x[3:2]=10, x[1:0]=10
            default: f = 1'b0;  // All other cases
        endcase
    end
endmodule