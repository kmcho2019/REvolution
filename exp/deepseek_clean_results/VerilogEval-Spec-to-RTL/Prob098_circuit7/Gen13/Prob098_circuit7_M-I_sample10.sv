module TopModule(input clk, input a, output q);
    reg a_prev;
    reg q_reg;
    
    assign q = q_reg;
    
    always @(posedge clk) begin
        if (a_prev == 0 && a == 1) begin  // rising edge detection
            q_reg <= 1;
        end
        else if (a_prev == 1 && a == 0) begin  // falling edge detection
            q_reg <= 0;
        end
        // else hold value
        a_prev <= a;
    end
endmodule