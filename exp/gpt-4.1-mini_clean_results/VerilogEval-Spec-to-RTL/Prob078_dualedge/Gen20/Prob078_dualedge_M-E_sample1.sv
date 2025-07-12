module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);

    reg d_pos;   // Data sampled on positive edge of clk
    wire clk_inv;

    // Invert the clock
    assign clk_inv = ~clk;

    // Sample 'd' on the rising edge of clk
    always @(posedge clk) begin
        d_pos <= d;
    end

    // Transparent latch enabled when clk is low (i.e., clk_inv is high)
    // When clk is low, latch is transparent and q follows d_pos.
    // When clk is high, q holds its value (latched).
    always @(clk_inv or d_pos) begin
        if (clk_inv) begin
            q <= d_pos;
        end
        // else q keeps its previous value (latch hold)
    end

endmodule