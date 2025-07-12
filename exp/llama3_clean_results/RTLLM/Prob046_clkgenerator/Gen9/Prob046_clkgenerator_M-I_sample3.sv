module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk,
    input clk_en, // Clock enable signal
    input rst_n // Active-low reset signal
);

localparam HALF_PERIOD = PERIOD / 2;
reg [3:0] counter; // Counter variable

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk <= 0; // Initialize clock signal on reset
        counter <= 0; // Initialize counter on reset
    end else if (clk_en) begin
        if (counter == HALF_PERIOD - 1) begin
            clk <= ~clk; // Toggle clock signal
            counter <= 0; // Reset counter
        end else begin
            counter <= counter + 1; // Increment counter
        end
    end
end

endmodule