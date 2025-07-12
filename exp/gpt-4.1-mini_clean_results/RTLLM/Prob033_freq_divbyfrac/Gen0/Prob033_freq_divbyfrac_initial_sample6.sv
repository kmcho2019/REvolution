module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters
    localparam MUL2_DIV_CLK = 7;  // 3.5 * 2

    // Counter that counts 0 to 6 (7 states)
    reg [2:0] cnt;

    // clk_div phase A, toggles every 4 or 3 cycles alternatively
    reg clk_div_a;
    // clk_div phase B, same but triggered on negedge clk, delayed by half clk
    reg clk_div_b;

    // Toggle flags to alternate between 4 and 3 cycle periods
    reg toggle_a;
    reg toggle_b;

    // Synchronous counter on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt      <= 3'd0;
            clk_div_a <= 1'b0;
            toggle_a <= 1'b0;
        end else begin
            // Increment counter modulo 7
            if (cnt == MUL2_DIV_CLK - 1)
                cnt <= 3'd0;
            else
                cnt <= cnt + 3'd1;

            // Toggle clk_div_a at cnt = 3 or 6 depending on toggle_a
            // The high period length is 4 cycles if toggle_a=0, else 3 cycles
            // So, toggle clk_div_a at:
            // For toggle_a=0: toggle at cnt=3 and cnt=6 (4 then 3 cycles)
            // For toggle_a=1: toggle at cnt=2 and cnt=6 (3 then 4 cycles)
            if ((toggle_a == 1'b0 && (cnt == 3 || cnt == 6)) ||
                (toggle_a == 1'b1 && (cnt == 2 || cnt == 6))) begin
                clk_div_a <= ~clk_div_a;
                if (cnt == 6)
                    toggle_a <= ~toggle_a;
            end
        end
    end

    // clk_div_b phase generation - triggered on negedge clk (half cycle shifted)
    // To implement phase B, we need a counter that aligns with phase A shifted by half clock
    reg [2:0] cnt_b;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_b      <= 3'd0;
            clk_div_b  <= 1'b0;
            toggle_b   <= 1'b0;
        end else begin
            // Increment counter modulo 7
            if (cnt_b == MUL2_DIV_CLK - 1)
                cnt_b <= 3'd0;
            else
                cnt_b <= cnt_b + 3'd1;

            // Toggle clk_div_b at cnt_b = 3 or 6 depending on toggle_b, same scheme as phase A
            if ((toggle_b == 1'b0 && (cnt_b == 3 || cnt_b == 6)) ||
                (toggle_b == 1'b1 && (cnt_b == 2 || cnt_b == 6))) begin
                clk_div_b <= ~clk_div_b;
                if (cnt_b == 6)
                    toggle_b <= ~toggle_b;
            end
        end
    end

    // OR both phases to produce final output
    assign clk_div = clk_div_a | clk_div_b;

endmodule