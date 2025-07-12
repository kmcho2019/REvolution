module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk = 0
);

    // Internal high-speed counter (width automatically adjusts to PERIOD)
    localparam COUNTER_WIDTH = $clog2(PERIOD);
    reg [COUNTER_WIDTH-1:0] counter = 0;

    // Clock generation process
    always begin
        #1; // Internal oscillator tick (minimum time unit)
        
        if (counter >= (PERIOD/2 - 1)) begin
            clk <= ~clk;
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end

endmodule