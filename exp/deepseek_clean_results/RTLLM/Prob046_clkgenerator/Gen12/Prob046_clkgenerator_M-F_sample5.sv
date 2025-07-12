module clkgenerator #(
    parameter PERIOD = 10      // Clock period in time units
)(
    input wire reset_n,        // Active-low reset
    output reg clk            // Generated clock output
);

    // Calculate half period for toggle point
    localparam HALF_PERIOD = PERIOD / 2;
    
    // Counter for clock generation
    integer counter;
    
    // Clock generation logic
    always @(*) begin
        if (!reset_n) begin
            clk = 1'b0;
            counter = 0;
        end
        else begin
            #1;  // Unit delay for simulation
            
            if (counter >= HALF_PERIOD - 1) begin
                clk = ~clk;
                counter = 0;
            end
            else begin
                counter = counter + 1;
            end
        end
    end

    // Initialize clock to 0
    initial begin
        clk = 1'b0;
    end

endmodule