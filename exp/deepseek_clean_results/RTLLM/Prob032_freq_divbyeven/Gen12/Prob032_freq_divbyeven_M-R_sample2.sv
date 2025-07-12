module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4;  // Must be even and >= 2

// Validate parameter
initial begin
    if (NUM_DIV < 2 || NUM_DIV[0] != 0) begin
        $error("NUM_DIV must be even and >= 2. Current value: %0d", NUM_DIV);
        $finish;
    end
end

reg [3:0] cnt;        // 4-bit counter
wire [3:0] next_cnt;  // Next counter value
wire toggle;          // Toggle signal for clock division

localparam CNT_LIMIT = (NUM_DIV/2) - 1;

// Combinational counter logic
assign next_cnt = (!rst_n) ? 4'b0 : 
                 (cnt == CNT_LIMIT) ? 4'b0 : cnt + 1;

// Toggle signal generation
assign toggle = (cnt == CNT_LIMIT) && rst_n;

// Sequential blocks
always @(posedge clk) begin
    cnt <= next_cnt;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 1'b0;
    end
    else if (toggle) begin
        clk_div <= ~clk_div;
    end
end

endmodule