module freq_divbyodd #(parameter NUM_DIV = 5) (
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);
    // Parameter check: NUM_DIV must be odd and >=3
    initial begin
        if (NUM_DIV < 3 || (NUM_DIV % 2) == 0) begin
            $error("NUM_DIV must be an odd number >= 3");
        end
    end

    localparam HALF_COUNT = (NUM_DIV - 1) / 2;
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            clk_div <= 0;
        end else begin
            if (counter == NUM_DIV - 1) begin
                counter <= 0;
                clk_div <= ~clk_div;       // Toggle output clk_div at end of count cycle
            end else begin
                counter <= counter + 1;
                if (counter == HALF_COUNT)
                    clk_div <= ~clk_div;   // Toggle output clk_div at midpoint count
            end
        end
    end

endmodule