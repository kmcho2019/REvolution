module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output wire CLK_50,
    output wire CLK_10,
    output wire CLK_1
);

    // 7-bit counter to count up to 99 (0 to 99)
    reg [6:0] counter;

    // Counter increments every clock; resets to zero at 99
    always @(posedge CLK_in) begin
        if (RST)
            counter <= 7'd0;
        else if (counter == 7'd99)
            counter <= 7'd0;
        else
            counter <= counter + 7'd1;
    end

    // CLK_50 toggles every 1 CLK_in cycle -> 100MHz/2 = 50MHz
    // So output is high when LSB of counter is 1 (count[0])
    assign CLK_50 = counter[0];

    // CLK_10 toggles every 5 CLK_in cycles -> 100MHz/10 = 10MHz
    // Full period = 10 cycles, so high for 5 cycles and low for 5 cycles
    // Use bit 3 as period counter: count[3] toggles every 8 counts (16 cycles)
    // Instead, define high for counts 0-4 and low for 5-9, repeat every 10 cycles
    wire [3:0] mod_10 = counter % 10;
    assign CLK_10 = (mod_10 < 5);

    // CLK_1 toggles every 50 CLK_in cycles -> 100MHz/100 = 1MHz
    // Full period = 100 cycles, high for 50 cycles and low for 50 cycles
    // Use counter value to generate clock high/low
    assign CLK_1 = (counter < 50);

endmodule