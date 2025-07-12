module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be an odd number
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Sanity check for odd divisor at elaboration time
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $display("Error: NUM_DIV (%0d) must be an odd number.", NUM_DIV);
            $finish;
        end
    end

    // Calculate high and low durations to achieve the divide-by-N with balanced duty cycle
    localparam integer HIGH_COUNT = (NUM_DIV + 1) / 2; // number of input clock cycles clk_div is high
    localparam integer LOW_COUNT  = (NUM_DIV - 1) / 2; // number of input clock cycles clk_div is low

    // Counter width calculation
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] counter;
    reg state; // 0: clk_div low, counting for low period; 1: clk_div high, counting for high period

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            clk_div <= 0;
            state   <= 0;
        end else begin
            if (state == 0) begin
                // clk_div is low, count low period
                if (counter == LOW_COUNT - 1) begin
                    counter <= 0;
                    clk_div <= 1;
                    state <= 1;
                end else begin
                    counter <= counter + 1;
                end
            end else begin
                // clk_div is high, count high period
                if (counter == HIGH_COUNT - 1) begin
                    counter <= 0;
                    clk_div <= 0;
                    state <= 0;
                end else begin
                    counter <= counter + 1;
                end
            end
        end
    end

endmodule