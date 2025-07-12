module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4;  // Must be even positive number

// Calculate required counter width based on NUM_DIV
localparam CNT_WIDTH = $clog2(NUM_DIV);
reg [CNT_WIDTH-1:0] cnt;

// Validate parameter (synthesis-time check)
initial begin
    if (NUM_DIV[0] || NUM_DIV < 2) begin
        $error("NUM_DIV must be even and >= 2");
        $finish;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= '0;
        clk_div <= 1'b0;
    end
    else begin
        // Toggle when counter reaches half period
        if (cnt == NUM_DIV>>1 - 1) begin
            cnt <= '0;
            clk_div <= ~clk_div;
        end
        else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule