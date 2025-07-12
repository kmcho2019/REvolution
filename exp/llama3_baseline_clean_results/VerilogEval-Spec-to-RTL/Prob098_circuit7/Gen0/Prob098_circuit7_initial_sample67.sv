module TopModule(clk, a, q);
    input clk;
    input a;
    output reg q;

    initial q = 1'b1;

    always @(posedge clk) begin
        if (a) begin
            q = ~q;
        end
    end
endmodule