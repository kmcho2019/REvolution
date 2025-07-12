module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    reg [31:0] counter;
    reg div_p, div_n;
    wire clk_n = ~clk;  // Inverted clock for negative edge
    localparam HALF_DIV = (NUM_DIV - 1) / 2;

    // Dual-edge counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            div_p <= 0;
        end else begin
            if (counter == NUM_DIV - 1) begin
                counter <= 0;
                div_p <= ~div_p;
            end else begin
                counter <= counter + 1;
            end
        end
    end

    // Negative edge triggered divider
    always @(posedge clk_n or negedge rst_n) begin
        if (!rst_n) begin
            div_n <= 0;
        end else begin
            if (counter == HALF_DIV) begin
                div_n <= ~div_n;
            end
        end
    end

    // Combine the two phase-shifted clocks
    assign clk_div = div_p | div_n;

endmodule