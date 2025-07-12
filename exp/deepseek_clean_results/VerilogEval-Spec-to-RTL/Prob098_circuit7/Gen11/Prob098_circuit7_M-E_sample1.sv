module TopModule(input clk, input a, output q);
    reg a_prev;
    reg q_reg;
    
    assign q = q_reg;
    
    always @(posedge clk) begin
        a_prev <= a;
        if (a_prev == 0 && a == 1) begin
            q_reg <= ~q_reg;
        end
    end
    
    initial begin
        a_prev = 0;
        q_reg = 1;  // Initial state matches waveform
    end
endmodule