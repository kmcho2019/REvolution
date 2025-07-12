module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Parameter validation
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

localparam HALF_CYCLE = (NUM_DIV - 1) / 2;
reg [31:0] pos_cnt, neg_cnt;
reg pos_pulse, neg_pulse;

// Positive edge domain
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pos_cnt <= 0;
        pos_pulse <= 0;
    end else begin
        if (pos_cnt == NUM_DIV - 1) begin
            pos_cnt <= 0;
            pos_pulse <= 1;
        end else begin
            pos_cnt <= pos_cnt + 1;
            pos_pulse <= (pos_cnt == HALF_CYCLE) ? 1 : 0;
        end
    end
end

// Negative edge domain
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        neg_cnt <= 0;
        neg_pulse <= 0;
    end else begin
        if (neg_cnt == NUM_DIV - 1) begin
            neg_cnt <= 0;
            neg_pulse <= 1;
        end else begin
            neg_cnt <= neg_cnt + 1;
            neg_pulse <= (neg_cnt == HALF_CYCLE) ? 1 : 0;
        end
    end
end

// Combine pulses to create final clock
assign clk_div = pos_pulse | neg_pulse;

endmodule