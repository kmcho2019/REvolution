module clkgenerator #(parameter PERIOD = 10) (
    input wire clk_in,      // Reference input clock
    output reg clk          // Generated clock output
);

    // Ensure PERIOD is at least 2 to avoid zero or negative half period
    localparam integer HALF_PERIOD = (PERIOD < 2) ? 1 : (PERIOD / 2);

    // Counter width to hold up to HALF_PERIOD
    localparam integer COUNTER_WIDTH = $clog2(HALF_PERIOD);

    reg [COUNTER_WIDTH-1:0] counter = 0;

    // Initialize clk to 0
    initial begin
        clk = 1'b0;
    end

    always @(posedge clk_in) begin
        if (counter == HALF_PERIOD - 1) begin
            counter <= 0;
            clk <= ~clk;
        end else begin
            counter <= counter + 1;
        end
    end

endmodule