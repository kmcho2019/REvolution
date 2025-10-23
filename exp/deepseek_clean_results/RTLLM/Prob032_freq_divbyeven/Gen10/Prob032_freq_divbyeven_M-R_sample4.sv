module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4; // Must be even number (2, 4, 6, ...)

reg [3:0] cnt;
wire toggle;

// Combinational logic for counter control
assign toggle = (cnt == (NUM_DIV/2 - 1));

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
    end else begin
        cnt <= toggle ? 0 : cnt + 1;
    end
end

// Clock divider logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 0;
    end else if (toggle) begin
        clk_div <= ~clk_div;
    end
end

endmodule