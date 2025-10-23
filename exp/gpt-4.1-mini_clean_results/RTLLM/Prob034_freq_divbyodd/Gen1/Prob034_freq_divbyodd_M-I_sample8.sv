module freq_divbyodd #(
    parameter NUM_DIV = 5  // Odd divisor, default 5
)(
    input  wire clk,
    input  wire rst_n,    // Active low reset
    output wire clk_div
);

    // Compile-time check for odd NUM_DIV
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV must be an odd number");
        end
    end

    localparam HALF = NUM_DIV >> 1; // floor(NUM_DIV/2)
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt1;
    reg [CNT_WIDTH-1:0] cnt2;
    reg clk_div1;
    reg clk_div2;

    // Positive edge clock domain
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1    <= 0;
            clk_div1 <= 1'b0; // Start at 0
        end else begin
            if (cnt1 == NUM_DIV - 1) begin
                cnt1 <= 0;
                clk_div1 <= ~clk_div1;
            end else if (cnt1 == HALF - 1) begin
                // toggle one half cycle before full count
                clk_div1 <= ~clk_div1;
                cnt1 <= cnt1 + 1;
            end else begin
                cnt1 <= cnt1 + 1;
            end
        end
    end

    // Negative edge clock domain
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2    <= 0;
            clk_div2 <= 1'b1; // Start at 1 for complementary phase
        end else begin
            if (cnt2 == NUM_DIV - 1) begin
                cnt2 <= 0;
                clk_div2 <= ~clk_div2;
            end else if (cnt2 == HALF -1) begin
                clk_div2 <= ~clk_div2;
                cnt2 <= cnt2 + 1;
            end else begin
                cnt2 <= cnt2 + 1;
            end
        end
    end

    assign clk_div = clk_div1 | clk_div2;

endmodule