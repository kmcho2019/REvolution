module freq_divbyodd #(
    parameter NUM_DIV = 5  // Odd divisor, default 5
)(
    input  wire clk,
    input  wire rst_n,    // Active low reset
    output wire clk_div
);

    // Check that NUM_DIV is odd at compile time
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV must be an odd number");
        end
    end

    localparam HALF = NUM_DIV >> 1; // integer division by 2, floor(NUM_DIV/2)

    reg [$clog2(NUM_DIV)-1:0] cnt1;
    reg [$clog2(NUM_DIV)-1:0] cnt2;
    reg clk_div1;
    reg clk_div2;

    // Counter and clk_div1 logic on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt1 == NUM_DIV - 1) begin
                cnt1 <= 0;
                clk_div1 <= ~clk_div1;
            end else if (cnt1 == HALF) begin
                clk_div1 <= ~clk_div1;
                cnt1 <= cnt1 + 1;
            end else begin
                cnt1 <= cnt1 + 1;
            end
        end
    end

    // Counter and clk_div2 logic on negedge clk
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt2 == NUM_DIV - 1) begin
                cnt2 <= 0;
                clk_div2 <= ~clk_div2;
            end else if (cnt2 == HALF) begin
                clk_div2 <= ~clk_div2;
                cnt2 <= cnt2 + 1;
            end else begin
                cnt2 <= cnt2 + 1;
            end
        end
    end

    assign clk_div = clk_div1 | clk_div2;

endmodule