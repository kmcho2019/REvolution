module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Simulation-time parameter validation
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

// Calculate required counter width and half periods
localparam CNT_WIDTH = $clog2(NUM_DIV);
localparam HIGH_CYCLES = (NUM_DIV + 1) / 2;  // ceil(N/2)
localparam LOW_CYCLES = (NUM_DIV - 1) / 2;   // floor(N/2)

reg [CNT_WIDTH-1:0] cnt_pos, cnt_neg;
reg clk_div_pos, clk_div_neg;

// Positive edge counter and divider
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_pos <= 0;
        clk_div_pos <= 0;
    end else begin
        if (cnt_pos == NUM_DIV - 1) begin
            cnt_pos <= 0;
        end else begin
            cnt_pos <= cnt_pos + 1;
        end
        
        // Toggle at transition point between high and low periods
        if (cnt_pos == HIGH_CYCLES - 1) begin
            clk_div_pos <= 0;
        end else if (cnt_pos == NUM_DIV - 1) begin
            clk_div_pos <= 1;
        end
    end
end

// Negative edge counter and divider
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_neg <= 0;
        clk_div_neg <= 0;
    end else begin
        if (cnt_neg == NUM_DIV - 1) begin
            cnt_neg <= 0;
        end else begin
            cnt_neg <= cnt_neg + 1;
        end
        
        // Toggle at transition point between high and low periods
        if (cnt_neg == HIGH_CYCLES - 1) begin
            clk_div_neg <= 0;
        end else if (cnt_neg == NUM_DIV - 1) begin
            clk_div_neg <= 1;
        end
    end
end

// Combine both edge dividers to create 50% duty cycle
assign clk_div = clk_div_pos | clk_div_neg;

endmodule