module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number >=3
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Parameter validation
initial begin
    if (NUM_DIV < 3 || NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number >= 3");
        $finish;
    end
end

localparam CNT_WIDTH = $clog2(NUM_DIV);
localparam HALF_CYCLE = (NUM_DIV - 1)/2;

reg [CNT_WIDTH-1:0] counter;
reg toggle_pos;
reg toggle_neg;

// Single counter on positive edge only
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
    end else begin
        if (counter == NUM_DIV - 1) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end
end

// Positive edge toggle (set at 0, clear at half cycle)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        toggle_pos <= 0;
    end else begin
        if (counter == 0) begin
            toggle_pos <= 1;
        end else if (counter == HALF_CYCLE) begin
            toggle_pos <= 0;
        end
    end
end

// Negative edge toggle (set at half cycle, clear at end)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        toggle_neg <= 0;
    end else begin
        if (counter == HALF_CYCLE) begin
            toggle_neg <= 1;
        end else if (counter == 0) begin
            toggle_neg <= 0;
        end
    end
end

// Combine toggle signals
assign clk_div = toggle_pos | toggle_neg;

endmodule