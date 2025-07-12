module TopModule(clk, a, q);
    input clk, a;
    output q;
    reg q;

    always @(posedge clk) begin
        if (a == 1'b0) begin
            q <= 1'b1;
        end else if (a == 1'b1) begin
            q <= ~q;
        end
    end
endmodule