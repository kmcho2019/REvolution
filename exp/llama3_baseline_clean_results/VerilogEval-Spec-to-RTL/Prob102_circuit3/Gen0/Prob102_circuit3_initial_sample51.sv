module TopModule(a, b, c, d, q);
    input a;
    input b;
    input c;
    input d;
    output q;
    reg q;

    always @(*) begin
        if (a || b) begin
            q = 1'b1;
        end else begin
            if (d) begin
                q = 1'b1;
            end else begin
                q = 1'b0;
            end
        end
    end
endmodule