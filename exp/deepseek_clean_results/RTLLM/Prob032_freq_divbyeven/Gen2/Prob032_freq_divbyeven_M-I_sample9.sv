module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4; // Default division factor (must be even)

// Validate parameter
initial begin
    if (NUM_DIV % 2 != 0) begin
        $error("NUM_DIV must be even");
        $finish;
    end
    if (NUM_DIV < 2) begin
        $error("NUM_DIV must be >= 2");
        $finish;
    end
end

localparam HALF_DIV = NUM_DIV / 2;
localparam CNT_WIDTH = $clog2(HALF_DIV);
reg [CNT_WIDTH-1:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= {CNT_WIDTH{1'b0}};
        clk_div <= 1'b0;
    end
    else if (cnt == HALF_DIV - 1) begin
        cnt <= {CNT_WIDTH{1'b0}};
        clk_div <= ~clk_div;
    end
    else begin
        cnt <= cnt + 1;
    end
end

endmodule