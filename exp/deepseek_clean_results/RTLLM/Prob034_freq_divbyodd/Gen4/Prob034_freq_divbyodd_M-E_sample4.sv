module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    reg clk_div_p, clk_div_n;
    reg [31:0] counter_p, counter_n;
    localparam HALF_CYCLE = (NUM_DIV - 1) / 2;

    // Positive edge counter and divider
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter_p <= 0;
            clk_div_p <= 0;
        end else begin
            if (counter_p == HALF_CYCLE) begin
                clk_div_p <= ~clk_div_p;
                counter_p <= counter_p + 1;
            end else if (counter_p == (NUM_DIV - 1)) begin
                clk_div_p <= ~clk_div_p;
                counter_p <= 0;
            end else begin
                counter_p <= counter_p + 1;
            end
        end
    end

    // Negative edge counter and divider
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter_n <= 0;
            clk_div_n <= 0;
        end else begin
            if (counter_n == HALF_CYCLE) begin
                clk_div_n <= ~clk_div_n;
                counter_n <= counter_n + 1;
            end else if (counter_n == (NUM_DIV - 1)) begin
                clk_div_n <= ~clk_div_n;
                counter_n <= 0;
            end else begin
                counter_n <= counter_n + 1;
            end
        end
    end

    // Combine the two divided clocks
    assign clk_div = clk_div_p ^ clk_div_n;

endmodule