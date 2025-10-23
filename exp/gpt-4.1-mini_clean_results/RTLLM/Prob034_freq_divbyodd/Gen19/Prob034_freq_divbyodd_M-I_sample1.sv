module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,    // Active low reset
    output wire clk_div
);

    // Compile-time check to ensure NUM_DIV is odd
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam integer HALF_DIV = NUM_DIV >> 1;  // integer division by 2
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt1;   // counts posedge clocks
    reg [CNT_WIDTH-1:0] cnt2;   // counts negedge clocks
    reg clk_div1, clk_div2;

    // Counter and clk_div1 toggle logic on positive edge of clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1    <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt1 == NUM_DIV - 1) begin
                cnt1 <= 0;
            end else begin
                cnt1 <= cnt1 + 1;
            end

            if (cnt1 == HALF_DIV) begin
                clk_div1 <= ~clk_div1;
            end
        end
    end

    // Counter and clk_div2 toggle logic on negative edge of clk
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2    <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt2 == NUM_DIV - 1) begin
                cnt2 <= 0;
            end else begin
                cnt2 <= cnt2 + 1;
            end

            if (cnt2 == HALF_DIV) begin
                clk_div2 <= ~clk_div2;
            end
        end
    end

    // Final divided clock output combining both halves
    assign clk_div = clk_div1 | clk_div2;

endmodule