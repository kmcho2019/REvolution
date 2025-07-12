module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters
    localparam integer DIV_MUL = 7;  // Counter modulus for 3.5x division

    // 3-bit synchronous counter counting 0..6
    reg [2:0] count;

    // Intermediate divided clocks toggled on posedge and negedge clk
    reg clk_int_a;  // toggled on posedge clk
    reg clk_int_b;  // toggled on negedge clk

    // Synchronous counter on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 3'd0;
        else if (count == DIV_MUL - 1)
            count <= 3'd0;
        else
            count <= count + 3'd1;
    end

    // clk_int_a generation (pos edge):
    // clk_int_a is high during count = 0..3 (4 cycles), low otherwise
    // Implement as a flip-flop toggling at specific count edges for duty cycle control

    // To generate clk_int_a:
    // Toggle clk_int_a at count == 0 to start high phase
    // Toggle clk_int_a at count == 4 to start low phase
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_int_a <= 1'b0;
        else if (count == 3'd0)
            clk_int_a <= 1'b1;  // start high
        else if (count == 3'd4)
            clk_int_a <= 1'b0;  // start low
    end

    // clk_int_b generation (neg edge):
    // clk_int_b is high during count = 3..5 (3 cycles), low otherwise
    // Toggle clk_int_b at negedge clk at count values 3 and 6 (wrapping 0)
    // Need to generate a negedge count. Use a delayed version of count to sample negedge state

    reg [2:0] count_delayed;  // delayed count registered on negedge clk

    // Sample count on negedge clk
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            count_delayed <= 3'd0;
        else
            count_delayed <= count;
    end

    // Generate clk_int_b on negedge clk:
    // clk_int_b set high at count_delayed == 3
    // clk_int_b set low at count_delayed == 6 (equiv 0 after wrap)
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_int_b <= 1'b0;
        else if (count_delayed == 3'd3)
            clk_int_b <= 1'b1;  // start high phase
        else if (count_delayed == 3'd6)
            clk_int_b <= 1'b0;  // start low phase
    end

    // Final output is OR of two intermediate signals
    assign clk_div = clk_int_a | clk_int_b;

endmodule