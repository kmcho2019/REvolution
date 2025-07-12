module freq_divbyfrac (
    input  wire clk,    // Input clock
    input  wire rst_n,  // Active low reset
    output wire clk_div // Fractionally divided output clock (divide by 3.5)
);

    reg [2:0] counter;

    // clk_intA: high for 4 cycles (counts 0..3)
    wire clk_intA = (counter <= 3'd3);

    // clk_intB_raw: high for 3 cycles (counts 4..6)
    wire clk_intB_raw = (counter >= 3'd4);

    // clk_intB registers sampled on posedge and negedge
    reg clk_intB_pos;
    reg clk_intB_neg;

    // Counter update on posedge clk, synchronous reset
    always @(posedge clk) begin
        if (!rst_n) begin
            counter <= 3'd0;
        end else begin
            if (counter == 3'd6)
                counter <= 3'd0;
            else
                counter <= counter + 3'd1;
        end
    end

    // Sample clk_intB_raw on posedge clk
    always @(posedge clk) begin
        if (!rst_n)
            clk_intB_pos <= 1'b0;
        else
            clk_intB_pos <= clk_intB_raw;
    end

    // Sample clk_intB_raw on negedge clk
    always @(negedge clk) begin
        if (!rst_n)
            clk_intB_neg <= 1'b0;
        else
            clk_intB_neg <= clk_intB_raw;
    end

    // Final divided clock is OR of clk_intA and clk_intB_neg (phase shifted half clock)
    assign clk_div = clk_intA | clk_intB_neg;

endmodule