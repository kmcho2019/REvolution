module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    wire clk_enable;
    wire gated_clk;

    // Clock gating control - enable only when input changes
    assign clk_enable = (in != prev_in);
    assign gated_clk = clk & clk_enable;

    always @(posedge gated_clk) begin
        anyedge <= in ^ prev_in;  // Detect any edge (0->1 or 1->0)
        prev_in <= in;            // Store current input for next cycle
    end

    // Reset anyedge to 0 when clock is gated to prevent false edges
    always @(posedge clk) begin
        if (!clk_enable) begin
            anyedge <= 8'b0;
        end
    end

endmodule