module freq_divbyodd #(parameter NUM_DIV = 5) (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);
    // Parameter validation
    initial begin
        if (NUM_DIV < 3 || (NUM_DIV % 2) == 0) begin
            $error("NUM_DIV must be an odd number >= 3");
        end
    end

    localparam CNT_WIDTH = $clog2(NUM_DIV);
    reg [CNT_WIDTH-1:0] counter;

    // Half counts for duty cycle boundaries
    localparam HIGH_TIME = (NUM_DIV + 1) >> 1; // Number of clk cycles clk_div is high
    // The clk_div is high for HIGH_TIME counts, low for NUM_DIV - HIGH_TIME counts

    // Counter increments from 0 to NUM_DIV-1 and wraps around
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
        end else begin
            if (counter == NUM_DIV - 1)
                counter <= 0;
            else
                counter <= counter + 1;
        end
    end

    // clk_div is high during the first HIGH_TIME counts, else low
    assign clk_div = (counter < HIGH_TIME) ? 1'b1 : 1'b0;

endmodule