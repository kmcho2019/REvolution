module TopModule(input clk, input a, output q);
    reg a_prev;
    reg q_reg;
    
    assign q = q_reg;
    
    always @(posedge clk) begin
        a_prev <= a;
        if (~a_prev & a) begin  // detect 0->1 transition
            q_reg <= 0;
        end else if (~a) begin   // when a=0, set q=1
            q_reg <= 1;
        end
        // otherwise q_reg maintains its value
    end
endmodule