module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Parameters for 3.5x division (7 cycles total)
localparam DIV_HIGH = 4;  // 4 cycles high
localparam DIV_LOW  = 3;  // 3 cycles low
localparam DIV_TOTAL = DIV_HIGH + DIV_LOW;

// Counter and clock generation registers
reg [2:0] cnt;
reg clk_0;
reg clk_180;

// Positive edge counter and clock generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 3'b0;
        clk_0 <= 1'b0;
    end else begin
        // Update counter
        cnt <= (cnt == DIV_TOTAL-1) ? 3'b0 : cnt + 1'b1;
        
        // Generate 0° phase clock
        clk_0 <= (cnt < DIV_HIGH) ? 1'b1 : 1'b0;
    end
end

// Negative edge clock generation (180° phase)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_180 <= 1'b0;
    end else begin
        // Generate 180° phase clock (same pattern as clk_0 but shifted)
        clk_180 <= (cnt < DIV_HIGH) ? 1'b1 : 1'b0;
    end
end

// Combine both phases
assign clk_div = clk_0 | clk_180;

endmodule