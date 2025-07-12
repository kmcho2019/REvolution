module TopModule (
    input  wire clk,
    input  wire reset,            // synchronous active-high reset
    input  wire pattern_detected, // pulse signal: high for one clk when pattern detected
    output wire shift_ena
);

    reg [2:0] count;
    reg reset_d;

    // Detect rising edge of reset (synchronous)
    always @(posedge clk) begin
        reset_d <= reset;
    end
    wire reset_pulse = reset & ~reset_d; // one-cycle pulse at reset rising edge

    // Counter reload control: reload counter to 4 on reset_pulse or pattern_detected pulse
    wire reload = reset_pulse | pattern_detected;

    always @(posedge clk) begin
        if (reload)
            count <= 3'd4;         // Load 4 cycles
        else if (count != 0)
            count <= count - 1;    // Count down each cycle
    end

    assign shift_ena = (count != 0);

endmodule