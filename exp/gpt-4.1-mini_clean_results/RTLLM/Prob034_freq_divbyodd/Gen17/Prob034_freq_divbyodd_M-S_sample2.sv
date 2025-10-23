module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,   // Active low reset
    output reg  clk_div
);

    // Compile-time check to ensure NUM_DIV is odd
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("Parameter NUM_DIV must be an odd number");
        end
    end

    localparam integer HALF_COUNT = (NUM_DIV - 1) / 2;

    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            clk_div <= 0;
        end else begin
            if (counter == NUM_DIV - 1)
                counter <= 0;
            else
                counter <= counter + 1;

            if (counter == 0 || counter == HALF_COUNT)
                clk_div <= ~clk_div;
        end
    end

endmodule