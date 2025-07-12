module clkgenerator #(
    parameter integer PERIOD = 10
) (
    input wire clk_in,      // Input clock
    input wire reset_n,     // Active-low synchronous reset
    output reg clk          // Generated clock output
);

    // Calculate half period count threshold
    localparam integer HALF_PERIOD = PERIOD / 2;

    reg [$clog2(PERIOD):0] count; // Counter width to cover PERIOD counts

    always @(posedge clk_in) begin
        if (!reset_n) begin
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