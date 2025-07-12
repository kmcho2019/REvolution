module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] clk_enable;
    wire gated_clk;

    // Generate clock enable signals for each bit
    assign clk_enable = (in != prev_in);

    // Clock gating cell (integrated in modern libraries)
    // This reduces power when inputs are stable
    assign gated_clk = clk & (|clk_enable);

    always @(posedge gated_clk) begin
        prev_in <= in;
        pedge <= in & ~prev_in;
    end

    // Default to 0 when clock is gated
    always @(negedge clk) begin
        if (!gated_clk) begin
            pedge <= 8'b0;
        end
    end

endmodule