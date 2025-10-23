module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,    // Active low reset
    output reg  clk_div
);

    // Compile-time check: NUM_DIV must be odd
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV must be odd");
        end
    end

    localparam HALF_DIV = NUM_DIV / 2;  // integer division (floor)

    // Counter width
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    // Count on rising edge of clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 0;
            clk_div <= 0;
        end else begin
            if (cnt == NUM_DIV - 1)
                cnt <= 0;
            else
                cnt <= cnt + 1;

            // Toggle clk_div at half division count
            if (cnt == HALF_DIV)
                clk_div <= ~clk_div;
        end
    end

    // Toggle clk_div again on falling edge when counter is zero (i.e., just wrapped)
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // clk_div is reset synchronously on posedge clk, so no action needed here
        end else begin
            if (cnt == 0)
                clk_div <= ~clk_div;
        end
    end

endmodule