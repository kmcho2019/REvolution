module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 6;  // Must be even number

// Validate parameter - generate error if odd
initial begin
    if (NUM_DIV % 2 != 0) begin
        $error("NUM_DIV must be an even number");
        $finish;
    end
end

// Calculate required counter width dynamically
localparam COUNTER_WIDTH = $clog2(NUM_DIV);
localparam DIV_HALF = NUM_DIV / 2 - 1;

reg [COUNTER_WIDTH-1:0] cnt;  // Dynamic width counter

// Counter and clock generation logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        clk_div <= 1'b0;
    end else begin
        // Counter increment and wrap-around
        if (cnt == NUM_DIV - 1) begin
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
        end
        
        // Toggle output at half period
        if (cnt == DIV_HALF) begin
            clk_div <= ~clk_div;
        end
    end
end

endmodule