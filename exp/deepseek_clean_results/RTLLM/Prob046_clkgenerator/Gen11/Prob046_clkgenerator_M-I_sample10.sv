module clkgenerator #(
    parameter PERIOD = 10,          // Clock period in time units
    parameter SIM_TIME = 1000       // Optional simulation stop time
)(
    output reg clk,                 // Clock output
    input wire enable = 1'b1        // Optional clock enable
);

    localparam HALF_PERIOD = PERIOD/2;

    initial begin
        clk = 1'b0;
        if (SIM_TIME > 0) #SIM_TIME $finish;
    end

    always begin
        if (enable) begin
            #HALF_PERIOD clk = ~clk;
        end
        else begin
            clk = 1'b0;
            #HALF_PERIOD;  // Maintain timing even when disabled
        end
    end

endmodule