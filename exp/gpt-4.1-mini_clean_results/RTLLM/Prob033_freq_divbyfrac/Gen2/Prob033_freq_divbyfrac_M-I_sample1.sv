module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam integer COUNT_MAX = 7; // 3.5 * 2

    reg [2:0] cnt_r;       // Counter on rising edge
    reg [2:0] cnt_f;       // Counter sampled on falling edge (half cycle delayed)
    reg       div_clk_a;   // Divided clock phase A (based on cnt_r)
    reg       div_clk_b;   // Divided clock phase B (based on cnt_f)

    // Counter increments on rising edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_r <= 3'd0;
        end else begin
            if (cnt_r == COUNT_MAX - 1)
                cnt_r <= 3'd0;
            else
                cnt_r <= cnt_r + 3'd1;
        end
    end

    // Generate div_clk_a: high for counts 0 to 3 (4 cycles), low for 4 to 6 (3 cycles)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            div_clk_a <= 1'b0;
        end else begin
            div_clk_a <= (cnt_r < 4);
        end
    end

    // Sample counter on falling edge to get half-cycle delayed count
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_f <= 3'd0;
        end else begin
            cnt_f <= cnt_r;
        end
    end

    // Generate div_clk_b based on half-cycle delayed count
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            div_clk_b <= 1'b0;
        end else begin
            div_clk_b <= (cnt_f < 4);
        end
    end

    // Final output clock is OR of two half-cycle shifted clocks
    assign clk_div = div_clk_a | div_clk_b;

endmodule