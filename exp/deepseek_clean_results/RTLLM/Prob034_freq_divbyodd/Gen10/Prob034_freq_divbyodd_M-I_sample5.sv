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

localparam CNT_WIDTH = $clog2(NUM_DIV);
localparam HALF_CYCLES = (NUM_DIV - 1) / 2;

// Positive edge domain (for rising edge of output)
reg [CNT_WIDTH-1:0] cnt_pos;
reg clk_div_pos;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_pos <= 0;
        clk_div_pos <= 0;
    end
    else begin
        if (cnt_pos == NUM_DIV - 1) begin
            cnt_pos <= 0;
        end
        else begin
            cnt_pos <= cnt_pos + 1;
        end
        
        // Toggle at half cycles
        if (cnt_pos == HALF_CYCLES - 1) begin
            clk_div_pos <= 1;
        end
        else if (cnt_pos == NUM_DIV - 1) begin
            clk_div_pos <= 0;
        end
    end
end

// Negative edge domain (for falling edge of output)
reg [CNT_WIDTH-1:0] cnt_neg;
reg clk_div_neg;
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_neg <= 0;
        clk_div_neg <= 0;
    end
    else begin
        if (cnt_neg == NUM_DIV - 1) begin
            cnt_neg <= 0;
        end
        else begin
            cnt_neg <= cnt_neg + 1;
        end
        
        // Toggle at half cycles
        if (cnt_neg == HALF_CYCLES - 1) begin
            clk_div_neg <= 1;
        end
        else if (cnt_neg == NUM_DIV - 1) begin
            clk_div_neg <= 0;
        end
    end
end

// Output generation - combine both edge domains with OR logic
assign clk_div = clk_div_pos | clk_div_neg;

endmodule