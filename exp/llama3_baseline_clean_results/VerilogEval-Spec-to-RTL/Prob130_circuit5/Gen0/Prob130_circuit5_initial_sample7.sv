module TopModule(
    input [3:0] a, 
    input [3:0] b, 
    input [3:0] c, 
    input [3:0] d, 
    input [3:0] e, 
    output [3:0] q
);

always @(a or b or c or d or e) begin
    case(c)
        0: q = b;
        1: q = e;
        2: q = a;
        3: q = d;
        default: 
            if(c == a || c == b || c == d || c == e)
                q = 4'b1111; // all ones (f)
            else
                q = 4'b1111; // all ones (f)
    endcase
end

endmodule