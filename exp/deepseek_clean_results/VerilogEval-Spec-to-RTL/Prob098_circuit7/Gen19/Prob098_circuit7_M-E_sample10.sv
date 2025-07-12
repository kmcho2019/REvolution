module TopModule(input clk, input a, output reg q);
    reg prev_a;
    
    always @(posedge clk) begin
        if (a != prev_a) begin  // Only update when 'a' changes
            q <= ~a;
            prev_a <= a;
        end
        // Else maintain current state
    end
endmodule