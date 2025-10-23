module freq_divbyfrac (
    input  wire clk,    // Input clock
    input  wire rst_n,  // Active low reset
    output wire clk_div // Fractionally divided output clock (divide by 3.5)
);

    // Counters for rising and falling edges: count 0 to 6 cyclically
    reg [2:0] cnt_r;
    reg [2:0] cnt_f;

    // Intermediate clocks generated on rising and falling edges
    reg clk_intA;
    reg clk_intB;

    // Rising edge counter: counts 0 to 6 repeatedly
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_r <= 3'd0;
        else if (cnt_r == 3'd6)
            cnt_r <= 3'd0;
        else
            cnt_r <= cnt_r + 3'd1;
    end

    // clk_intA updated on rising edge: high for counts 0-3 (4 cycles), low otherwise
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_intA <= 1'b0;
        else if (cnt_r <= 3'd3)
            clk_intA <= 1'b1;
        else
            clk_intA <= 1'b0;
    end

    // Falling edge counter: counts 0 to 6 repeatedly
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_f <= 3'd0;
        else if (cnt_f == 3'd6)
            cnt_f <= 3'd0;
        else
            cnt_f <= cnt_f + 3'd1;
    end

    // clk_intB updated on falling edge: high for counts 3-5 (3 cycles), low otherwise
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_intB <= 1'b0;
        else if ((cnt_f >= 3'd3) && (cnt_f <= 3'd5))
            clk_intB <= 1'b1;
        else
            clk_intB <= 1'b0;
    end

    // Output clock: OR of clk_intA and clk_intB gives fractional division with half-cycle phase shift
    assign clk_div = clk_intA | clk_intB;

endmodule