module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Parameters for 3.5x division (7 cycles total)
localparam DIV_VALUE = 7;
localparam PHASE_SHIFT = DIV_VALUE/2; // 3.5 cycles delay for second phase

// Counter and clock generation for primary phase
reg [2:0] counter_p;
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

// Counter and clock generation for secondary phase (delayed)
reg [2:0] counter_s;
reg clk_s;
reg [1:0] delay_counter;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        delay_counter <= 0;
        counter_s <= 0;
        clk_s <= 0;
    end else begin
        // Implement 3.5 cycle delay before starting second counter
        if (delay_counter < 2'b11) begin
            delay_counter <= delay_counter + 1;
        end else if (delay_counter == 2'b11) begin
            delay_counter <= 2'b11; // Hold at max value
            if (counter_s == DIV_VALUE-1) begin
                counter_s <= 0;
                clk_s <= ~clk_s;
            end else begin
                counter_s <= counter_s + 1;
            end
        end
    end
end

// Output synchronization and combination
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