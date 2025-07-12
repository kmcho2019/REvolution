module TopModule(input clk, input a, output reg q);
    reg a_prev;
    
    always @(posedge clk) begin
        if (a != a_prev) begin
            q <= ~q;
            a_prev <= a;
        end
    end
endmodule