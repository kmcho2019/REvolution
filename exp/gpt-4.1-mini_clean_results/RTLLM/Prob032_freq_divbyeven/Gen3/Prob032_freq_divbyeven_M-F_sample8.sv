module freq_divbyeven #(
    parameter NUM_DIV = 4  // must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Calculate counter width based on NUM_DIV to support larger dividers
    localparam CNT_WIDTH = (NUM_DIV > 0) ? $clog2(NUM_DIV/2) : 1;

    reg [CNT_WIDTH-1:0] cnt;

    // Synthesis tools do not support runtime checks; ensure NUM_DIV is even when setting parameter.
    // This module assumes NUM_DIV is an even positive integer.

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 0;
            clk_div <= 0;
        end else if (cnt == (NUM_DIV/2 - 1)) begin
            cnt     <= 0;
            clk_div <= ~clk_div;
        end else begin
            cnt <= cnt + 1;
        end
    end

endmodule