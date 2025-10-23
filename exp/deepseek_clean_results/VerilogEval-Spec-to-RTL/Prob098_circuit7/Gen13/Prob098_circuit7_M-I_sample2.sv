module TopModule(input clk, input a, output q);
    reg q_reg = 1'b1;  // Initialize to 1
    reg a_prev;
    
    assign q = q_reg;
    
    always @(posedge clk) begin
        a_prev <= a;
        if (a_prev == 0 && a == 1) begin  // Rising edge detection
            q_reg <= 0;
        end
        // Otherwise q_reg maintains its value
    end
endmodule