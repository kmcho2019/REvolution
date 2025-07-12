module TopModule(
    input  [3:0] x, // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output       f
);

    reg f_reg;

    always @(*) begin
        case (x)
            4'b1100, // x4=1,x3=1,x2=0,x1=0 (row=11, col=00) f=1
            4'b1101, // x4=1,x3=1,x2=0,x1=1 (row=11, col=01) f=1
            4'b0111, // x4=0,x3=1,x2=1,x1=1 (row=01, col=11) f=1
            4'b1000, // x4=1,x3=0,x2=0,x1=0 (row=10, col=00) f=1
            4'b1001, // x4=1,x3=0,x2=0,x1=1 (row=10, col=01) f=1
            4'b1010, // x4=1,x3=0,x2=1,x1=0 (row=10, col=10) d - assigned 0 here
            4'b1011, // x4=1,x3=0,x2=1,x1=1 (row=10, col=11) d - assigned 0 here
            4'b0011, // x4=0,x3=0,x2=1,x1=1 (row=00, col=11) d - assign 0
            4'b0001: // x4=0,x3=0,x2=0,x1=1 (row=00, col=01) 0
                f_reg = 0;
            4'b0101: // x4=0,x3=1,x2=0,x1=1 (row=01, col=01) d - assign 0
                f_reg = 0;
            4'b0110: // x4=0,x3=1,x2=1,x1=0 (row=01, col=10) 0
                f_reg = 0;
            default: // rest 0 or don't care assigned 0
                f_reg = 0;
        endcase
        // Set f=1 for the marked minterms explicitly above
        if (x == 4'b1100 || x == 4'b1101 || x == 4'b0111 || x == 4'b1000 || x == 4'b1001)
            f_reg = 1;
    end

    assign f = f_reg;

endmodule