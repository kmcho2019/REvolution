module TopModule(input clk, input a, output reg q);
    reg a_prev;
    
    always @(posedge clk) begin
        a_prev <= a;
        q <= (a & ~a_prev) ? 1'b1 : 1'b0;
    end
endmodule