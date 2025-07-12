module freq_divbyodd #(
    parameter NUM_DIV = 5  // Odd number divisor
)(
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Sanity check for odd divisor
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $display("Error: NUM_DIV must be an odd number.");
            $finish;
        end
    end

    // We count twice the frequency (both edges), so the total count is NUM_DIV * 2
    localparam COUNT_MAX = NUM_DIV * 2;

    // The half count where the clk_div toggles
    localparam TOGGLE_COUNT = NUM_DIV;

    reg [$clog2(COUNT_MAX)-1:0] cnt;
    reg clk_div_reg;

    // This block triggers on both edges of clk to effectively count half cycles
    // As Verilog doesn't allow posedge and negedge in the same sensitivity list, we create a 
    // combined clock enable by toggling on both edges using clk and a delayed clk.
    // Here we use a trick with a clock domain crossing: We will create an enable signal for counting
    // by XORing clk and a registered clk (to detect edges), but the simplest is to use a double-edge clock
    // style via a clock enable approach:
    //
    // To remain synthesizable and clean, we implement two always blocks for posedge and negedge clk,
    // both calling the same counter increment logic. However, to avoid separate counters, we unify into one
    // by incrementing a shared counter on posedge and negedge.

    // Counter increments on both edges
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_div_reg <= 0;
        end else begin
            if (cnt == COUNT_MAX - 1) begin
                cnt <= 0;
                clk_div_reg <= ~clk_div_reg; // toggle output at full cycle
            end else begin
                cnt <= cnt + 1;
                // toggle clk_div_reg at half cycle to get a 50% duty cycle clock
                if (cnt == TOGGLE_COUNT - 1) begin
                    clk_div_reg <= ~clk_div_reg;
                end
            end
        end
    end

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // handled in posedge block, ignore here
        end else begin
            if (cnt == COUNT_MAX - 1) begin
                cnt <= 0;
                clk_div_reg <= ~clk_div_reg; // toggle output at full cycle
            end else begin
                cnt <= cnt + 1;
                if (cnt == TOGGLE_COUNT - 1) begin
                    clk_div_reg <= ~clk_div_reg;
                end
            end
        end
    end

    assign clk_div = clk_div_reg;

endmodule