module clkgenerator #(parameter PERIOD = 10) (
    output reg clk
);

    // Calculate counter width needed for the given PERIOD
    localparam COUNTER_WIDTH = $clog2(PERIOD);
    reg [COUNTER_WIDTH-1:0] counter;
    
    // Calculate the toggle point (handles both even and odd periods)
    localparam HALF_PERIOD = (PERIOD >> 1);
    
    initial begin
        clk = 1'b0;
        counter = 0;
    end

    always @(posedge clk or negedge clk) begin
        if (counter >= PERIOD-1)
            counter <= 0;
        else
            counter <= counter + 1;
            
        // Toggle clock at half period mark
        if (counter == HALF_PERIOD-1)
            clk <= ~clk;
    end
endmodule