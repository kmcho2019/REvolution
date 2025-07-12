module TopModule(input clk, input a, output reg q);
    reg a_prev;
    
    always @(posedge clk) begin
        if (~a_prev & a)  // Detect 0->1 transition
            q <= ~q;
        a_prev <= a;
    end
endmodule