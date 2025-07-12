module clkgenerator #(
    parameter PERIOD = 10
) (
    input wire clk_in,    // Reference input clock
    input wire rst_n,     // Active-low synchronous reset
    output reg clk        // Generated clock output
);

localparam HALF_PERIOD = PERIOD / 2;

reg [$clog2(PERIOD):0] counter; // Enough bits to count up to PERIOD

always @(posedge clk_in or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        clk <= 0;
    end else begin
        if (counter == HALF_PERIOD - 1) begin
            clk <= ~clk;
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end
end

endmodule