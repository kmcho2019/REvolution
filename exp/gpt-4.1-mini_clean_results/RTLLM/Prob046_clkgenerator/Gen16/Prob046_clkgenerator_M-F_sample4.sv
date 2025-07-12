module clkgenerator #(
    parameter PERIOD = 10
) (
    input wire clk_in,
    input wire rst,
    output reg clk = 0
);

    // Calculate half period count
    // To avoid zero or negative values, handle PERIOD < 2 gracefully
    localparam HALF_PERIOD = (PERIOD < 2) ? 1 : (PERIOD / 2);

    reg [$clog2(HALF_PERIOD):0] counter = 0;

    always @(posedge clk_in) begin
        if (rst) begin
            counter <= 0;
            clk <= 0;
        end else begin
            if (counter == HALF_PERIOD - 1) begin
                counter <= 0;
                clk <= ~clk;
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule