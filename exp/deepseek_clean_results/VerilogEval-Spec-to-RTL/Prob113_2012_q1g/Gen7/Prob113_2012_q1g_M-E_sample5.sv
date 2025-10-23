module TopModule(
    input [3:0] x,
    output reg f
);
    always @(*) begin
        case (x)
            4'b0000: f = 1;  // x3=0,x2=0,x1=0,x0=0
            4'b0001: f = 0;  // x3=0,x2=0,x1=0,x0=1
            4'b0010: f = 1;  // x3=0,x2=0,x1=1,x0=0
            4'b0011: f = 0;  // x3=0,x2=0,x1=1,x0=1
            4'b0100: f = 0;  // x3=0,x2=1,x1=0,x0=0
            4'b0101: f = 0;  // x3=0,x2=1,x1=0,x0=1
            4'b0110: f = 0;  // x3=0,x2=1,x1=1,x0=0
            4'b0111: f = 0;  // x3=0,x2=1,x1=1,x0=1
            4'b1000: f = 1;  // x3=1,x2=0,x1=0,x0=0
            4'b1001: f = 1;  // x3=1,x2=0,x1=0,x0=1
            4'b1010: f = 1;  // x3=1,x2=0,x1=1,x0=0
            4'b1011: f = 0;  // x3=1,x2=0,x1=1,x0=1
            4'b1100: f = 1;  // x3=1,x2=1,x1=0,x0=0
            4'b1101: f = 1;  // x3=1,x2=1,x1=0,x0=1
            4'b1110: f = 0;  // x3=1,x2=1,x1=1,x0=0
            4'b1111: f = 1;  // x3=1,x2=1,x1=1,x0=1
            default: f = 0;  // should never occur with 4-bit input
        endcase
    end
endmodule