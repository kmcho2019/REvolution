module TopModule(a, b, c, d, e, q);
    input [3:0] a, b, c, d, e;
    output [3:0] q;
    
    always @(*) begin
        case(c)
            4'b0000: q = b; // c = 0
            4'b0001: q = e; // c = 1
            4'b0010: q = a; // c = 2
            4'b0011: q = d; // c = 3
            default: q = 4'b1111; // c >= 4, output 'f' (don't care or undefined)
        endcase
    end
endmodule