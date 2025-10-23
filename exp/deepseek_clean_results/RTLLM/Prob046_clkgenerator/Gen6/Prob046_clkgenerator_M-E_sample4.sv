module clkgenerator #(
    parameter PERIOD = 10
) (
    output reg clk
);

    // Internal counter (width enough for PERIOD)
    reg [31:0] counter = 0;
    
    // Base clock for the counter (simulated here)
    reg base_clk = 0;
    
    // Threshold for clock toggle (half period)
    localparam THRESHOLD = PERIOD / 2;
    
    // Generate base clock (for simulation)
    always #1 base_clk = ~base_clk;
    
    // Main counter and clock generation
    always @(posedge base_clk) begin
        if (counter >= PERIOD-1) begin
            counter <= 0;
            clk <= 1'b0;  // Reset clock at period boundary
        end else begin
            counter <= counter + 1;
            
            // Toggle clock at half period
            if (counter == THRESHOLD-1) begin
                clk <= 1'b1;
            end
        end
    end
    
    // Initialization
    initial begin
        clk = 1'b0;
        counter = 0;
    end

endmodule