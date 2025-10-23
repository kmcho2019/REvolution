module clkgenerator #(
    parameter integer PERIOD = 10
) (
    input  wire clk_in,  // Reference input clock
    output reg  clk      // Output clock signal
);

    // Width of counter depends on PERIOD
    localparam integer CNT_WIDTH = $clog2(PERIOD);

    reg [CNT_WIDTH-1:0] counter = 0;

    always @(posedge clk_in) begin
        if (counter == (PERIOD/2 - 1)) begin
            counter <= 0;
            clk <= ~clk;
        end else begin
            counter <= counter + 1;
        end
    end

    // Optional: initialize clk at 0 at power-up (synthesis tools will handle reset/init)
    initial clk = 1'b0;

endmodule