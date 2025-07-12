module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

    // Double-rate counter (counts both edges)
    localparam DOUBLE_COUNT = 2 * NUM_DIV;
    reg [$clog2(DOUBLE_COUNT)-1:0] edge_counter;

    // Transition points for 50% duty cycle
    localparam RISING_POINT = NUM_DIV;
    localparam FALLING_POINT = (3 * NUM_DIV) / 2;

    always @(posedge clk or negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            edge_counter <= 0;
            clk_div <= 0;
        end
        else begin
            // Increment counter on both edges
            edge_counter <= (edge_counter == DOUBLE_COUNT - 1) ? 0 : edge_counter + 1;

            // State transitions for output clock
            case (edge_counter)
                RISING_POINT - 1: clk_div <= 1'b1;
                FALLING_POINT - 1: clk_div <= 1'b0;
                default: clk_div <= clk_div;
            endcase
        end
    end

endmodule