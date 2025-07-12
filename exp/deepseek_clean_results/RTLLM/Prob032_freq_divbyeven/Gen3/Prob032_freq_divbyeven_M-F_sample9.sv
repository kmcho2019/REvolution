module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

// Even division factor (must be even)
parameter NUM_DIV = 4;

// Validate parameter (simulation-time check)
initial begin
    if (NUM_DIV % 2 != 0) begin
        $error("NUM_DIV must be even (current value: %0d)", NUM_DIV);
        $finish;
    end
end

// Derived constants
localparam HALF_DIV = NUM_DIV / 2;
localparam CNT_WIDTH = $clog2(NUM_DIV);

// Counter register
reg [CNT_WIDTH-1:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Active-low reset initialization
        cnt <= '0;
        clk_div <= 1'b0;
    end
    else begin
        if (cnt == HALF_DIV - 1) begin
            // Toggle output and reset counter
            cnt <= '0;
            clk_div <= ~clk_div;
        end
        else begin
            // Increment counter
            cnt <= cnt + 1;
        end
    end
end

endmodule