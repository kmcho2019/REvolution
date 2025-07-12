module TopModule (
    input clk,
    input d,
    output reg q
);

    // Internal signal toggles every clk rising edge: acts like half-rate enable
    reg clk_toggle = 0;
    reg d_sampled_pos = 0;
    reg d_sampled_neg = 0;

    always @(posedge clk) begin
        clk_toggle <= ~clk_toggle; // Toggle every posedge clk

        if (~clk_toggle) begin
            // On even clk_toggle cycles, sample input d to d_sampled_pos
            d_sampled_pos <= d;
        end else begin
            // On odd clk_toggle cycles, sample input d to d_sampled_neg
            d_sampled_neg <= d;
        end
    end

    always @(posedge clk) begin
        // Output q follows the sampled data alternately on half clock cycles
        if (~clk_toggle)
            q <= d_sampled_pos;
        else
            q <= d_sampled_neg;
    end

endmodule