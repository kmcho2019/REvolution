module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Counters for positive and negative edge triggered clocks
    reg [2:0] pos_counter;
    reg       pos_clk_int;

    reg [2:0] neg_counter;
    reg       neg_clk_int;

    // On rising edge: count up to 4 cycles, toggle pos_clk_int
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pos_counter <= 3'd0;
            pos_clk_int <= 1'b0;
        end else begin
            if (pos_counter == 3) begin  // 4 cycles: count 0..3
                pos_counter <= 3'd0;
                pos_clk_int <= ~pos_clk_int;
            end else begin
                pos_counter <= pos_counter + 3'd1;
            end
        end
    end

    // On falling edge: count up to 3 cycles, toggle neg_clk_int
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            neg_counter <= 3'd0;
            neg_clk_int <= 1'b0;
        end else begin
            if (neg_counter == 2) begin  // 3 cycles: count 0..2
                neg_counter <= 3'd0;
                neg_clk_int <= ~neg_clk_int;
            end else begin
                neg_counter <= neg_counter + 3'd1;
            end
        end
    end

    // Final fractional divided clock: OR of two phase-shifted clocks
    assign clk_div = pos_clk_int | neg_clk_int;

endmodule