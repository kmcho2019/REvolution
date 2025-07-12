module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam integer DIV_MUL = 7;  // Divide by 7 base

    reg [2:0] count;    // counts 0..6
    reg       neg_clk_d; // toggles at negedge clk for phase shift

    // Counter increments on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 3'd0;
        else if (count == DIV_MUL - 1)
            count <= 3'd0;
        else
            count <= count + 3'd1;
    end

    // Toggle neg_clk_d at negedge clk for half cycle phase shift
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            neg_clk_d <= 1'b0;
        else
            neg_clk_d <= ~neg_clk_d;
    end

    // clk_int_a high for counts 0..3 (4 cycles)
    wire clk_int_a = (count < 4);

    // clk_int_b high for counts 4..6 (3 cycles), enabled only when neg_clk_d is high (half-cycle shifted)
    wire clk_int_b = neg_clk_d && (count >= 4);

    // Final output is OR of both pulses
    assign clk_div = clk_int_a || clk_int_b;

endmodule