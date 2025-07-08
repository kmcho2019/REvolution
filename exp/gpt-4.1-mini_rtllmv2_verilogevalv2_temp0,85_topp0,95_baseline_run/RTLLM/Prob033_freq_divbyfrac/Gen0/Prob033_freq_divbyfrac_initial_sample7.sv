module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

// Parameters
localparam integer DIV_VAL = 7; // 3.5 * 2
localparam integer HALF_CYCLE_1 = 4; // First half period in clk cycles
localparam integer HALF_CYCLE_2 = 3; // Second half period in clk cycles

// Counter from 0 to 6
reg [2:0] cnt_rise;
reg [2:0] cnt_fall;

// Intermediate divided clocks updated on rising and falling edges
reg clk_rise_int;
reg clk_fall_int;

// Counters and clocks on rising edge
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_rise     <= 3'd0;
        clk_rise_int <= 1'b0;
    end else begin
        if (clk_rise_int == 1'b0) begin
            // clk low period
            if (cnt_rise == ( (clk_rise_int ? HALF_CYCLE_2 : HALF_CYCLE_1) - 1 ))
                clk_rise_int <= 1'b1;
        end else begin
            // clk high period
            if (cnt_rise == ( (clk_rise_int ? HALF_CYCLE_2 : HALF_CYCLE_1) - 1 )) begin
                clk_rise_int <= 1'b0;
            end
        end

        // Increment counter modulo current half cycle count
        if (clk_rise_int == 1'b0) begin
            if (cnt_rise == (HALF_CYCLE_1 - 1))
                cnt_rise <= 3'd0;
            else
                cnt_rise <= cnt_rise + 3'd1;
        end else begin
            if (cnt_rise == (HALF_CYCLE_2 - 1))
                cnt_rise <= 3'd0;
            else
                cnt_rise <= cnt_rise + 3'd1;
        end
    end
end

// Counters and clocks on falling edge
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_fall     <= 3'd0;
        clk_fall_int <= 1'b0;
    end else begin
        if (clk_fall_int == 1'b0) begin
            // clk low period
            if (cnt_fall == ( (clk_fall_int ? HALF_CYCLE_2 : HALF_CYCLE_1) - 1 ))
                clk_fall_int <= 1'b1;
        end else begin
            // clk high period
            if (cnt_fall == ( (clk_fall_int ? HALF_CYCLE_2 : HALF_CYCLE_1) - 1 )) begin
                clk_fall_int <= 1'b0;
            end
        end

        // Increment counter modulo current half cycle count
        if (clk_fall_int == 1'b0) begin
            if (cnt_fall == (HALF_CYCLE_1 - 1))
                cnt_fall <= 3'd0;
            else
                cnt_fall <= cnt_fall + 3'd1;
        end else begin
            if (cnt_fall == (HALF_CYCLE_2 - 1))
                cnt_fall <= 3'd0;
            else
                cnt_fall <= cnt_fall + 3'd1;
        end
    end
end

// Final output clock is OR of two intermediate clocks, combining phase-shifted signals
assign clk_div = clk_rise_int | clk_fall_int;

endmodule