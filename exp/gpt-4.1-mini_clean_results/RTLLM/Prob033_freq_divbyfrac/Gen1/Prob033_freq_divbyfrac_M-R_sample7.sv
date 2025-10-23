module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam integer DIV2 = 7; // Twice the division ratio (3.5 * 2)

    reg [2:0] count;          // 3-bit counter 0..6
    reg       toggle;         // toggles to create base divided clock (phase A)
    reg       toggle_delayed; // delayed toggle to create phase B (half-cycle shifted)

    // Counter increments every posedge clk, modulo DIV2
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 3'd0;
        else begin
            if (count == DIV2 - 1)
                count <= 3'd0;
            else
                count <= count + 3'd1;
        end
    end

    // toggle signal changes state at count = 3 and 6 to get uneven periods of 4 and 3 clk cycles
    // starting from toggle=0, at count=3 toggle toggles, at count=6 toggle toggles again
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            toggle <= 1'b0;
        else if (count == 3 || count == 6)
            toggle <= ~toggle;
    end

    // Delayed toggle register to create phase shifted clock (half clk period delayed)
    // This is equivalent to toggling toggle_delayed on the next clock cycle after toggle changes
    reg toggle_d1;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            toggle_d1 <= 1'b0;
            toggle_delayed <= 1'b0;
        end else begin
            toggle_d1 <= toggle;
            toggle_delayed <= toggle_d1;
        end
    end

    // OR of toggle and toggle_delayed creates fractional clk output with uniform period and balanced duty cycle
    assign clk_div = toggle | toggle_delayed;

endmodule