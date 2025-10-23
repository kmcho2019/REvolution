module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock signal
    input wire valid_count,    // Enable counting when high
    output reg [3:0] out       // 4-bit counter output
);

reg valid_count_reg;
wire gated_clk;
reg clk_en;

// Clock gating logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_en <= 1'b0;
        valid_count_reg <= 1'b0;
    end else begin
        valid_count_reg <= valid_count;
        clk_en <= valid_count;
    end
end

assign gated_clk = clk & clk_en;

// Counter logic with gated clock
always @(posedge gated_clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else begin
        out <= out + 1'b1;
    end
end

endmodule