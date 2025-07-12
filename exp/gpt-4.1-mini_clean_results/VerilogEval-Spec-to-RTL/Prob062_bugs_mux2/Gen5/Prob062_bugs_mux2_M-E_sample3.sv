module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output reg   out
);

    always @(*) begin
        case(sel)
            1'b0: out = a[0]; // select bit 0 of input 'a'
            1'b1: out = b[0]; // select bit 0 of input 'b'
            default: out = 1'b0;
        endcase
    end

endmodule