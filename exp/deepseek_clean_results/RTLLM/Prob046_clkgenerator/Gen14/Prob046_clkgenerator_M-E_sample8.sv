module clkgenerator #(
    parameter PERIOD = 10       // Clock period in time units
)(
    output reg clk             // Generated clock output
);

    localparam HALF_PERIOD = PERIOD / 2;
    integer counter = 0;

    initial begin
        clk = 1'b0;            // Initialize clock to 0
        forever begin
            #1;               // Increment time precisely
            counter = counter + 1;
            
            if (counter >= PERIOD) begin
                counter = 0;
            end
            else if (counter == HALF_PERIOD) begin
                clk = ~clk;   // Toggle at half period
            end
        end
    end

endmodule