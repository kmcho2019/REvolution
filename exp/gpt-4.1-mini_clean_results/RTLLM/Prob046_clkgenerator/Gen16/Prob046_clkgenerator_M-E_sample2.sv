module clkgenerator #(
    parameter PERIOD = 10  // Must be even for 50% duty cycle
) (
    input wire clk_in,
    input wire reset_n,    // active-low synchronous reset
    output reg clk = 0
);

    // Width of counter needed to count up to PERIOD/2 - 1
    localparam CNT_WIDTH = $clog2(PERIOD/2);

    reg [CNT_WIDTH-1:0] counter;

    always @(posedge clk_in) begin
        if (!reset_n) begin
            counter <= 0;
            clk <= 0;
        end else begin
            if (counter == (PERIOD/2 - 1)) begin
                counter <= 0;
                clk <= ~clk;
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule