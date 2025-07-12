module TopModule(input clk, input a, output reg q);
    reg a_prev;
    
    always @(posedge clk) begin
        a_prev <= a;
        
        if (~a_prev && a) begin  // rising edge detection
            q <= 1'b1;
        end
        else if (~a) begin       // reset when a is low
            q <= 1'b0;
        end
    end
endmodule