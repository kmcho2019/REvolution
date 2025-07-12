module freq_diveven (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

parameter NUM_DIV = 6; // Default division factor (must be even)

// Calculate required counter width based on NUM_DIV
localparam CNT_WIDTH = $clog2(NUM_DIV);
localparam CNT_MAX = (NUM_DIV/2) - 1;

// Validate parameter (synthesis-time check)
initial begin
    if (NUM_DIV % 2 != 0) begin
        $error("NUM_DIV must be an even number");
    end
end

reg [CNT_WIDTH-1:0] cnt; // Dynamic width counter
wire [CNT_WIDTH-1:0] cnt_next;
reg div_toggle;

// Counter next state logic
assign cnt_next = (!rst_n) ? 0 : 
                 (cnt == CNT_MAX) ? 0 : cnt + 1;

// Clock division logic
assign clk_div = div_toggle;

always @(posedge clk) begin
    if (!rst_n) begin
        cnt <= 0;
        div_toggle <= 0;
    end
    else begin
        cnt <= cnt_next;
        if (cnt == CNT_MAX) begin
            div_toggle <= ~div_toggle;
        end
    end
end

endmodule