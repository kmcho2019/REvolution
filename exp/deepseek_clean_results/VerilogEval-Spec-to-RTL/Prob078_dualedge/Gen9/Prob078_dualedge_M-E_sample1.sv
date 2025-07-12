module TopModule (
    input clk,
    input d,
    output reg q
);

    reg prev_clk;  // Stores previous clock value
    
    // Edge detection and data capture
    always @(posedge clk, negedge clk) begin
        if (prev_clk ^ clk) begin  // Any edge detection
            q <= d;                // Capture data
            prev_clk <= clk;       // Update clock history
        end
    end

endmodule