module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

// Parameters for 3.5x division (7 cycles total)
localparam DIV_HIGH = 4;  // 4 cycles high
localparam DIV_LOW  = 3;  // 3 cycles low
localparam DIV_TOTAL = DIV_HIGH + DIV_LOW;

// Counter and clock generation registers
reg [2:0] cnt;
reg clk_0;
reg clk_180;
wire clk_div_comb;

// Positive edge counter and clock generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 3'b0;
        clk_0 <= 1'b0;
    end else begin
        // Update counter with modulo arithmetic
        cnt <= (cnt == DIV_TOTAL-1) ? 3'b0 : cnt + 1'b1;
        
        // Generate base clock (0° phase)
        if (cnt < DIV_HIGH) begin
            clk_0 <= 1'b1;
        end else begin
            clk_0 <= 1'b0;
        end
    end
end

// Negative edge clock generation (180° phase)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_180 <= 1'b0;
    end else begin
        // Calculate phase-shifted threshold (offset by half period)
        // Using (cnt + DIV_HIGH) % DIV_TOTAL
        if (((cnt + DIV_HIGH) % DIV_TOTAL) < DIV_HIGH) begin
            clk_180 <= 1'b1;
        end else begin
            clk_180 <= 1'b0;
        end
    end
end

// Combine phases with proper synchronization
assign clk_div_comb = clk_0 | clk_180;

// Register output to prevent glitches
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 1'b0;
    end else begin
        clk_div <= clk_div_comb;
    end
end

endmodule