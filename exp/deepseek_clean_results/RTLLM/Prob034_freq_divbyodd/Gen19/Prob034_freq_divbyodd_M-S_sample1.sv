module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Check if NUM_DIV is odd
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

localparam HALF_CYCLE = (NUM_DIV - 1) >> 1;
reg [31:0] cnt;
reg clk_pos, clk_neg;

// Counter that increments on both edges
always @(posedge clk or negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        clk_pos <= 0;
        clk_neg <= 0;
    end else begin
        cnt <= (cnt == NUM_DIV - 1) ? 0 : cnt + 1;
        
        // Toggle on positive edge at midpoint
        if (posedge clk) begin
            clk_pos <= (cnt == HALF_CYCLE) ? ~clk_pos : clk_pos;
        end
        
        // Toggle on negative edge at midpoint
        if (negedge clk) begin
            clk_neg <= (cnt == HALF_CYCLE) ? ~clk_neg : clk_neg;
        end
    end
end

// Final output combines both edges
assign clk_div = clk_pos ^ clk_neg;

endmodule