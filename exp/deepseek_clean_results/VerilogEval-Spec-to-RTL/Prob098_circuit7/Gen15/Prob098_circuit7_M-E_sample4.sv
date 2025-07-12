module TopModule(input clk, input a, output q);
    reg state;
    reg a_prev;
    
    assign q = state;
    
    always @(posedge clk) begin
        a_prev <= a;
        if (~a_prev & a) begin  // detect rising edge of a
            state <= ~state;   // toggle state
        end
    end
    
    initial begin
        state = 1'b1;  // initial state when a=0
        a_prev = 1'b0;
    end
endmodule