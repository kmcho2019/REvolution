module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,    // Active low reset
    output wire clk_div
);

    // Compile-time check for odd NUM_DIV
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam integer HALF_DIV = NUM_DIV / 2;

    // Counter width to cover NUM_DIV - 1
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    // Counter for rising edge domain
    reg [CNT_WIDTH-1:0] cnt_r;
    reg clk_div_r;

    // Counter for falling edge domain
    reg [CNT_WIDTH-1:0] cnt_f;
    reg clk_div_f;

    // Rising edge counter and clk_div_r toggle logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_r     <= 0;
            clk_div_r <= 0;
        end else begin
            if (cnt_r == NUM_DIV - 1)
                cnt_r <= 0;
            else
                cnt_r <= cnt_r + 1;

            if (cnt_r == HALF_DIV)
                clk_div_r <= ~clk_div_r;
        end
    end

    // Falling edge counter and clk_div_f toggle logic
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_f     <= 0;
            clk_div_f <= 0;
        end else begin
            if (cnt_f == NUM_DIV - 1)
                cnt_f <= 0;
            else
                cnt_f <= cnt_f + 1;

            if (cnt_f == HALF_DIV)
                clk_div_f <= ~clk_div_f;
        end
    end

    // Output clock is OR of both divided clocks
    assign clk_div = clk_div_r | clk_div_f;

endmodule