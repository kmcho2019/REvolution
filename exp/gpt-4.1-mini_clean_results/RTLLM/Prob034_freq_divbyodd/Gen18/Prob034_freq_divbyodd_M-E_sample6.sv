module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,     // Active low asynchronous reset
    output wire clk_div
);

    // Compile-time check for odd NUM_DIV
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam integer HALF_DIV = NUM_DIV / 2;  // floor division

    // Width for counter (minimum bits to count up to NUM_DIV-1)
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    // Counter from 0 to NUM_DIV-1
    reg [CNT_WIDTH-1:0] cnt;

    // Toggle flip-flops for generating divided clock edges
    reg tog1;
    reg tog2;

    // Counter logic: counts up each clk posedge, resets asynchronously
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
        end else begin
            if (cnt == NUM_DIV - 1)
                cnt <= 0;
            else
                cnt <= cnt + 1;
        end
    end

    // Toggle tog1 at count == 0 (rising edge of output clock)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tog1 <= 1'b0;
        end else if (cnt == 0) begin
            tog1 <= ~tog1;
        end
    end

    // Toggle tog2 at count == HALF_DIV (falling edge of output clock)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tog2 <= 1'b0;
        end else if (cnt == HALF_DIV) begin
            tog2 <= ~tog2;
        end
    end

    // Generate output clock by XOR of two toggles
    // This produces a frequency divided by NUM_DIV clock with ~50% duty cycle for odd NUM_DIV
    assign clk_div = tog1 ^ tog2;

endmodule