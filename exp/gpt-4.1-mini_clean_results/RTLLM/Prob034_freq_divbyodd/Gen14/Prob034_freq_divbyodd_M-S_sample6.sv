module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,    // Active low reset
    output reg  clk_div
);

    // Compile-time check for odd NUM_DIV
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam integer HALF_DIV = (NUM_DIV - 1) >> 1;  // (NUM_DIV-1)/2

    // Width for counter
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

            // clk_div is high for first HALF_DIV+1 counts, then low
            if (counter <= HALF_DIV)
                clk_div <= 1'b1;
            else
                clk_div <= 1'b0;
        end
    end

endmodule