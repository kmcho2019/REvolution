module clkgenerator #(
    parameter PERIOD = 10
)(
    input wire clk_base,    // Base clock input (higher frequency)
    input wire reset_n,     // Active-low reset
    output reg clk_out      // Generated clock output
);

    reg [31:0] counter;
    
    always @(posedge clk_base or negedge reset_n) begin
        if (!reset_n) begin
            // Reset state
            counter <= 0;
            clk_out <= 0;
        end
        else begin
            // Increment counter
            counter <= counter + 1;
            
            // Check for toggle points
            if (counter == ((PERIOD/2)-1)) begin
                clk_out <= ~clk_out;
            end
            else if (counter == (PERIOD-1)) begin
                clk_out <= ~clk_out;
                counter <= 0;
            end
        end
    end

endmodule