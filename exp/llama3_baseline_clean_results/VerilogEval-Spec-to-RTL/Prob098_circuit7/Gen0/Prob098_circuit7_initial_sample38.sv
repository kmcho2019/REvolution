module TopModule(clk, a, q);
    input clk, a;
    output q;
    reg q;

    always @(posedge clk) begin
        if (a == 1) begin
            q = ~q;
        end else if (q == 1'bx) begin // on first reset
            q = 1;
        end
    end
endmodule