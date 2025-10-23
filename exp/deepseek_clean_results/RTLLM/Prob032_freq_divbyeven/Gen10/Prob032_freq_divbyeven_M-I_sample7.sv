module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4; // Must be even number (2, 4, 6, ...)

// Calculate required counter width dynamically
localparam COUNTER_WIDTH = $clog2(NUM_DIV/2);
localparam COUNT_LIMIT = (NUM_DIV/2) - 1;

reg [COUNTER_WIDTH-1:0] cnt;

// Check for even NUM_DIV during simulation
initial begin
    if (NUM_DIV % 2 != 0) begin
        $display("Warning: NUM_DIV should be even, got %0d", NUM_DIV);
    end
    if (NUM_DIV/2 > (2**COUNTER_WIDTH)) begin
        $display("Error: NUM_DIV %0d exceeds counter capacity", NUM_DIV);
        $finish;
    end
end

// Counter and clock division logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        clk_div <= 0;
    end else begin
        if (cnt == COUNT_LIMIT) begin
            cnt <= 0;
            clk_div <= ~clk_div; // Toggle every NUM_DIV/2 cycles
        end else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule