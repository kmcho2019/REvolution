module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,     // Active low reset
    output reg  clk_div
);

    // Compile-time assertion to check NUM_DIV is odd
    initial begin
        if ((NUM_DIV % 2) == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam integer HALF_COUNT = NUM_DIV / 2; // floor division

    // Minimum width for counter
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            clk_div <= 0;
        end else begin
            if (counter == NUM_DIV - 1) begin
                counter <= 0;
                clk_div <= ~clk_div; // toggle clk_div at end of count
            end else begin
                counter <= counter + 1;
                if (counter == HALF_COUNT - 1) begin
                    clk_div <= ~clk_div; // toggle clk_div at half count
                end
            end
        end
    end

endmodule