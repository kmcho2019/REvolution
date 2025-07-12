module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters
    localparam DIV_MOD = 7; // 7 cycles per full division period

    reg [2:0] counter;

    // clk_intA: high for counts 0..3 (4 cycles), low for 4..6 (3 cycles)
    reg clk_intA;

    // clk_intB: clk_intA delayed by half clock cycle (implemented by toggling on negedge clk)
    reg clk_intB;

    // Counter increments on rising edge, resets on rst_n low
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 3'd0;
            clk_intA <= 1'b0;
        end else begin
            if (counter == DIV_MOD - 1)
                counter <= 3'd0;
            else
                counter <= counter + 3'd1;

            // clk_intA high for counts 0..3 (4 cycles), low for 4..6 (3 cycles)
            clk_intA <= (counter < 4) ? 1'b1 : 1'b0;
        end
    end

    // clk_intB generates half-cycle phase-shifted clk_intA by toggling on falling edge of clk
    // Assign clk_intB on negedge clk using clk_intA sampled at posedge clk
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_intB <= 1'b0;
        end else begin
            // Update clk_intB with clk_intA value at the previous posedge clk (half-cycle shifted)
            clk_intB <= clk_intA;
        end
    end

    // Final fractional clock output is OR of clk_intA and clk_intB to fill the half-cycle gaps
    assign clk_div = clk_intA | clk_intB;

endmodule