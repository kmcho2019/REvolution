module freq_diveven (
    input clk,
    input rst_n,
    output clk_div
);

parameter NUM_DIV = 6;  // Must be even number >= 2

// Parameter validation
initial begin
    if (NUM_DIV < 2 || NUM_DIV[0] != 0) begin
        $error("NUM_DIV must be even number >= 2");
        $finish;
    end
end

localparam CNT_WIDTH = $clog2(NUM_DIV/2);
localparam TERM_CNT = NUM_DIV/2 - 1;

reg [CNT_WIDTH-1:0] cnt;
reg toggle;

// Down counter implementation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= TERM_CNT;
    end
    else begin
        cnt <= (cnt == 0) ? TERM_CNT : cnt - 1;
    end
end

// Toggle control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        toggle <= 1'b0;
    end
    else if (cnt == 0) begin
        toggle <= ~toggle;
    end
end

// Continuous output assignment
assign clk_div = toggle;

endmodule