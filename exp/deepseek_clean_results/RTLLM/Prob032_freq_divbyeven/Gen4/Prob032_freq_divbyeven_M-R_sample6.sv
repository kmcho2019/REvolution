module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4; // Even division factor (2,4,6,...)

reg [3:0] cnt; // 4-bit counter
wire cnt_reset; // Counter reset condition

// Combinational logic for counter control
assign cnt_reset = (cnt == (NUM_DIV/2 - 1));

// Counter sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
    end else if (cnt_reset) begin
        cnt <= 0;
    end else begin
        cnt <= cnt + 1;
    end
end

// Clock divider toggle logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 0;
    end else if (cnt_reset) begin
        clk_div <= ~clk_div;
    end
end

endmodule