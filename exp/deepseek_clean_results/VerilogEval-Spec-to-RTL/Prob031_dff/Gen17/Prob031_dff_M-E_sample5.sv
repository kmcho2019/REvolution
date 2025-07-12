module TopModule(input clk, input d, output reg q);
    wire enable = q ^ d;  // Enable only when input differs from current state
    
    always @(posedge clk) begin
        if (enable) q <= d;  // Conditional update
    end
endmodule