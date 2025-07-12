module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

    localparam CNT_MAX = 2*NUM_DIV - 1;  // Double resolution for edge precision
    localparam CNT_WIDTH = $clog2(CNT_MAX+1);
    localparam THRESH_HIGH = NUM_DIV - 1;
    localparam THRESH_LOW = 2*NUM_DIV - 2;

    reg [CNT_WIDTH-1:0] counter;
    wire counter_reset = (counter == CNT_MAX);

    // Dual-edge counter with automatic reset
    always @(posedge clk or negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
        end else begin
            counter <= counter_reset ? 0 : counter + 1;
        end
    end

    // Dynamic output generation with symmetric control
    always @(posedge clk or negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div <= 0;
        end else begin
            // Rising edge condition
            if (counter == 0) clk_div <= 1;
            // Falling edge condition
            if (counter == THRESH_HIGH) clk_div <= 0;
            // Automatic correction for counter overflow
            if (counter_reset) clk_div <= 0;
        end
    end

endmodule