module freq_divbyfrac (
    input  wire clk,    // Input clock
    input  wire rst_n,  // Active low reset
    output wire clk_div // Fractionally divided output clock (divide by 3.5)
);

    // Parameter for double the division value (7 for 3.5 division)
    localparam CNT_MAX = 3'd6;

    reg [2:0] cnt;

    // Counter cycles from 0 to 6 on posedge clk with synchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == CNT_MAX)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    //
    // Generate toggle pulses for clk_intA and clk_intB:
    //
    // For 3.5 division:
    // clk_intA toggles 4 times per cycle (4 toggle points within 7 clk cycles)
    // clk_intB toggles 3 times per cycle (3 toggle points within 7 clk cycles)
    //
    // To spread toggles evenly and provide half-cycle phase shift:
    //
    // clk_intA toggles on cnt = 0,1,2,3  (4 toggles)
    // clk_intB toggles on cnt = 4,5,6    (3 toggles)
    //
    // clk_intA toggles on posedge clk when toggle_pulse_A is high
    // clk_intB toggles on negedge clk when toggle_pulse_B is high

    wire toggle_pulse_A = (cnt <= 3'd3);      // high when cnt=0..3 inclusive
    wire toggle_pulse_B = (cnt >= 3'd4);      // high when cnt=4..6 inclusive

    // To create one-clock-cycle wide toggle pulses on posedge clk,
    // use a registered version of toggle pulse to detect rising edges

    reg toggle_pulse_A_d;
    reg toggle_pulse_B_d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            toggle_pulse_A_d <= 1'b0;
            toggle_pulse_B_d <= 1'b0;
        end else begin
            toggle_pulse_A_d <= toggle_pulse_A;
            toggle_pulse_B_d <= toggle_pulse_B;
        end
    end

    // Generate one-clock toggle pulses by detecting rising edges of toggle signals
    wire toggle_event_A = toggle_pulse_A & ~toggle_pulse_A_d; // pulse when toggle_pulse_A rises
    wire toggle_event_B_clk = toggle_pulse_B & ~toggle_pulse_B_d; // same for toggle_pulse_B on posedge

    //
    // Since toggle_event_B is derived on posedge clk, but clk_intB toggles on negedge clk,
    // we need to synchronize toggle_event_B to negedge clk domain:
    //

    reg toggle_event_B_negedge_sync;

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            toggle_event_B_negedge_sync <= 1'b0;
        else
            toggle_event_B_negedge_sync <= toggle_event_B_clk;
    end

    // Internal toggle flip-flops for clk_intA (posedge clk) and clk_intB (negedge clk)
    reg clk_intA;
    reg clk_intB;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_intA <= 1'b0;
        else if (toggle_event_A)
            clk_intA <= ~clk_intA;
    end

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_intB <= 1'b0;
        else if (toggle_event_B_negedge_sync)
            clk_intB <= ~clk_intB;
    end

    // Final output clock is OR of two half-cycle shifted clocks
    assign clk_div = clk_intA | clk_intB;

endmodule