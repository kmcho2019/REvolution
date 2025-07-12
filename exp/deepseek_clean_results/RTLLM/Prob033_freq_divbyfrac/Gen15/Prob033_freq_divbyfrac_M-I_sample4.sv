module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Parameters for 3.5x division (7 cycles total)
localparam DIV_VALUE = 7;
localparam COUNTER_WIDTH = 3;

// Primary phase (positive edge triggered)
reg [COUNTER_WIDTH-1:0] counter_p;
reg clk_p;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter_p <= 0;
        clk_p <= 0;
    end else begin
        if (counter_p == DIV_VALUE-1) begin
            counter_p <= 0;
            clk_p <= ~clk_p;
        end else begin
            counter_p <= counter_p + 1;
        end
    end
end

// Secondary phase (negative edge triggered for 0.5 cycle offset)
reg [COUNTER_WIDTH-1:0] counter_s;
reg clk_s;

always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter_s <= 0;
        clk_s <= 0;
    end else begin
        if (counter_s == DIV_VALUE-1) begin
            counter_s <= 0;
            clk_s <= ~clk_s;
        end else begin
            counter_s <= counter_s + 1;
        end
    end
end

// Synchronize outputs to avoid glitches
reg clk_p_sync, clk_s_sync;

always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_p_sync <= 0;
        clk_s_sync <= 0;
    end else begin
        clk_p_sync <= clk_p;
        clk_s_sync <= clk_s;
    end
end

// Final output combination
assign clk_div = clk_p_sync | clk_s_sync;

endmodule