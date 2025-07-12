module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    wire clk_enable;
    wire gated_clk;

    // Clock gating logic - only enable when input changes
    assign clk_enable = (in != prev_in);
    assign gated_clk = clk & clk_enable;

    always @(posedge gated_clk) begin
        prev_in <= in;            // Store current input for next cycle
        anyedge <= in ^ prev_in;   // Detect transitions between current and previous cycle
    end

    // Reset behavior when clock is gated
    always @(negedge clk_enable) begin
        if (!clk_enable) begin
            anyedge <= 8'b0;
        end
    end

endmodule