module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam MUL2_DIV_CLK = 7; // Total cycles for 3.5 division

    reg [2:0] cnt;
    reg clk_a, clk_b;

    // Counter increments on positive edge of clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt   <= 3'd0;
            clk_a <= 1'b0;
            clk_b <= 1'b0;
        end else begin
            if (cnt == MUL2_DIV_CLK - 1)
                cnt <= 3'd0;
            else
                cnt <= cnt + 3'd1;

            // clk_a toggles at count 0 and 4: high for 4 cycles, low for 3 cycles
            if (cnt == 3'd0 || cnt == 3'd4)
                clk_a <= ~clk_a;

            // clk_b toggles at count 0 and 3: high for 3 cycles, low for 4 cycles
            if (cnt == 3'd0 || cnt == 3'd3)
                clk_b <= ~clk_b;
        end
    end

    // Generate delayed clk by delaying clk by one half cycle using a register and clk negedge
    reg clk_delayed;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_delayed <= 1'b0;
        else
            clk_delayed <= clk;
    end

    // Phase shifted clk_b by half clock: delay clk_b by one half cycle using clk_delayed as enable
    reg clk_b_shifted;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_b_shifted <= 1'b0;
        else
            clk_b_shifted <= clk_b;
    end

    // Final output clock: OR of clk_a and clk_b_shifted (phase-shifted)
    assign clk_div = clk_a | clk_b_shifted;

endmodule