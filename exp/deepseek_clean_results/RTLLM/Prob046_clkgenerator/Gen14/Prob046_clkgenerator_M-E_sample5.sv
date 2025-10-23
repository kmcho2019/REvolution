module clkgenerator #(
    parameter PERIOD = 10       // Clock period in time units
)(
    output reg clk             // Generated clock output
);

    reg [31:0] counter = 0;    // Free-running counter
    localparam HALF_PERIOD = PERIOD / 2;

    always begin
        #1;  // Time step
        counter = counter + 1;
        
        if (counter >= PERIOD) begin
            counter = 0;
            clk = 1'b0;
        end
        else if (counter == HALF_PERIOD) begin
            clk = 1'b1;
        end
    end

    initial begin
        clk = 1'b0;  // Initial state
    end

endmodule