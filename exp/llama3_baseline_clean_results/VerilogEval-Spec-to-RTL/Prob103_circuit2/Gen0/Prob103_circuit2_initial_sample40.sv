module TopModule(a, b, c, d, q);
    input a, b, c, d;
    output q;
    reg q;

    always @(*)
    begin
        if ((a ^ d) || (b ^ c)) begin
            if (a && (b == c)) begin
                q = 0;
            end else if (~a && (b != c)) begin
                q = 1;
            end else begin
                q = (a ^ d) ^ (b ^ c);
            end
        end else begin
            q = 0;
        end
    end
endmodule