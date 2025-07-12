module TopModule(a, b, c, d, e, q);
    input [3:0] a, b, c, d, e;
    output [3:0] q;

    reg [3:0] q;

    always @(a or b or c or d or e) begin
        if (c == 4'b0000) q = b; // c is 0, select b
        else if (c == 4'b0001) q = e; // c is 1, select e
        else if (c == 4'b0010) q = a; // c is 2, select a
        else if (c == 4'b0011) q = d; // c is 3, select d
        else q = 4'b1111; // for c values greater than 3, set q to all ones
    end
endmodule