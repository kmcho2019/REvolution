module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Counter counts from 0 to 6 (7 states) for 3.5 division cycle
    reg [2:0] counter;

    // Synchronous modulo-7 counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter <= 3'd0;
        else if (counter == 3'd6)
            counter <= 3'd0;
        else
            counter <= counter + 3'd1;
    end

    // clk_a: high for counts 0..3 (4 cycles), low for 4..6 (3 cycles)
    wire clk_a = (counter <= 3'd3);

    // Phase shift the counter by 3 modulo 7 to approximate half period shift
    wire [2:0] counter_shift = (counter >= 3'd4) ? (counter - 3'd4) : (counter + 3'd3);

    // clk_b: same duty cycle but phase shifted by ~half clock period
    wire clk_b = (counter_shift <= 3'd3);

    // OR the two waveforms to create fractional divide-by-3.5 clock
    assign clk_div = clk_a | clk_b;

endmodule