module freq_diveven (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

parameter NUM_DIV = 4; // Must be even number (2, 4, 6, ...)

reg [3:0] cnt; // 4-bit counter supports division up to 30
reg toggle;

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
    end else if (cnt == NUM_DIV/2 - 1) begin
        cnt <= 0;
    end else begin
        cnt <= cnt + 1;
    end
end

// Toggle generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        toggle <= 0;
    end else if (cnt == NUM_DIV/2 - 1) begin
        toggle <= ~toggle;
    end
end

// Clock output generation
assign clk_div = toggle;

endmodule