module TopModule (
    input wire clk,
    input wire d,
    output reg q
);

    reg d_reg_pos, d_reg_neg;     // Data sampled on posedge and 'falling edge' enable
    reg clk_dly;

    // Delay the clock by one cycle to generate falling edge detection
    always @(posedge clk) begin
        clk_dly <= clk;
    end

    // Generate a pulse that is high only for one clk cycle after a falling edge
    wire falling_edge_enable = clk_dly & (~clk);

    // Positive edge sampling of data
    always @(posedge clk) begin
        d_reg_pos <= d;
    end

    // "Negative edge" sampling by using falling_edge_enable as clock enable
    always @(posedge clk) begin
        if (falling_edge_enable)
            d_reg_neg <= d;
    end

    // Output latch: update output at every positive edge with either posedge or negedge sampled data
    // Since falling_edge_enable lasts only one cycle, output updates with d_reg_neg shortly after falling edge
    // We use a mux controlled by clk to select between posedge and negedge sampled data
    always @(posedge clk) begin
        if (clk)
            q <= d_reg_pos;
        else
            q <= d_reg_neg;
    end

endmodule