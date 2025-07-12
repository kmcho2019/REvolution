module freq_divbyodd (
    input  clk,       // Input clock signal
    input  rst_n,     // Active low reset signal
    output reg clk_div // Divided clock output
);

parameter NUM_DIV = 5; // Default odd divisor value

reg [2:0] cnt; // Counter for clock divider
reg       clk_div1; // Clock divider for positive edge
reg       clk_div2; // Clock divider for negative edge
reg       clk_edge; // Flag for clock edge

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        clk_div1 <= 0;
        clk_div2 <= 0;
        clk_edge <= 0;
    end else begin
        if (cnt == (NUM_DIV - 1) / 2) begin
            clk_div1 <= ~clk_div1;
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
        end
        if (clk_edge) begin
            clk_div2 <= ~clk_div2;
        end
        clk_edge <= ~clk_edge;
    end
end

always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // No action on negedge clk
    end else begin
        // No action on negedge clk
    end
end

assign clk_div = clk_div1 | clk_div2;

endmodule