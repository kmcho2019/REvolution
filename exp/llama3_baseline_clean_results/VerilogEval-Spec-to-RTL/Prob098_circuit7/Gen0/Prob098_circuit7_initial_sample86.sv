module TopModule(clk, a, q);
    input clk;
    input a;
    output q;
    reg q;

    always @(posedge clk) begin
        if (a == 1'b0 && q == 1'bx) begin
            q <= 1'b1;
        end else if (a == 1'b1) begin
            q <= ~q;
        end
    end
endmodule