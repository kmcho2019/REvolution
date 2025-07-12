module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] main_counter;
reg [1:0] div3_counter;
reg [2:0] div4_counter;
reg div3_clock, div4_clock;
reg phase_a, phase_b;

// Main 7-cycle counter
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        main_counter <= 3'b0;
    end else begin
        main_counter <= (main_counter == 3'd6) ? 3'b0 : main_counter + 1'b1;
    end
end

// 3x divider (period = 3 cycles)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        div3_counter <= 2'b0;
        div3_clock <= 1'b0;
    end else begin
        if (div3_counter == 2'd2) begin
            div3_counter <= 2'b0;
            div3_clock <= ~div3_clock;
        end else begin
            div3_counter <= div3_counter + 1'b1;
        end
    end
end

// 4x divider (period = 4 cycles)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        div4_counter <= 3'b0;
        div4_clock <= 1'b0;
    end else begin
        if (div4_counter == 3'd3) begin
            div4_counter <= 3'b0;
            div4_clock <= ~div4_clock;
        end else begin
            div4_counter <= div4_counter + 1'b1;
        end
    end
end

// Phase interpolation logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_a <= 1'b0;
        phase_b <= 1'b0;
    end else begin
        // First phase (aligned with 3x divider)
        phase_a <= div3_clock;
        
        // Second phase (shifted by half period)
        if (main_counter == 3'd3) begin
            phase_b <= ~phase_b;
        end
    end
end

// Output combination with majority voting
assign clk_div = (phase_a & phase_b) | 
                 (phase_a & (main_counter < 3'd4)) | 
                 (phase_b & (main_counter >= 3'd3));

endmodule