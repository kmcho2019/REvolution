module TopModule(input clk, input a, output reg q);
    reg a_prev, a_prev2;
    wire a_rising;
    
    initial q = 1'b1;  // Initial state as per waveform
    
    always @(posedge clk) begin
        a_prev <= a;
        a_prev2 <= a_prev;
    end
    
    assign a_rising = a_prev & ~a_prev2;
    
    always @(posedge clk) begin
        if (a_rising)
            q <= 1'b0;
        // else maintain value
    end
endmodule