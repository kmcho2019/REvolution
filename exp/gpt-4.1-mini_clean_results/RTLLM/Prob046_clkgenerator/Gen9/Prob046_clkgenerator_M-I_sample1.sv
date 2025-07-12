module clkgenerator #(
    parameter integer PERIOD = 10
) (
    input wire clk_in,  // Base clock input
    input wire rst_n,   // Active low synchronous reset
    output reg clk      // Generated clock output
);

    // HALF_PERIOD is number of input clock cycles for half output clock period
    localparam integer HALF_PERIOD = PERIOD / 2;

    reg [$clog2(HALF_PERIOD+1)-1:0] count;

    always @(posedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
            clk <= 1'b0;
            count <= 0;
        end else begin
            if (count == HALF_PERIOD - 1) begin
                clk <= ~clk;
                count <= 0;
            end else begin
                count <= count + 1;
            end
        end
    end

endmodule