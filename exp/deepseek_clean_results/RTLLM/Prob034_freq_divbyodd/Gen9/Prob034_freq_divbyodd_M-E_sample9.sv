module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

    reg [31:0] counter;
    wire toggle_high, toggle_low;
    localparam FULL_CYCLE = 2 * NUM_DIV;  // Double counting for both edges
    localparam TOGGLE_POINT = NUM_DIV;    // Midpoint for toggle

    // Toggle conditions
    assign toggle_high = (counter == TOGGLE_POINT - 1);
    assign toggle_low = (counter == FULL_CYCLE - 1);

    // Dual-edge counter
    always @(posedge clk or negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
        end else begin
            if (counter == FULL_CYCLE - 1)
                counter <= 0;
            else
                counter <= counter + 1;
        end
    end

    // Clock generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div <= 1'b0;
        end else begin
            if (toggle_high)
                clk_div <= 1'b1;
            else if (toggle_low)
                clk_div <= 1'b0;
        end
    end

endmodule