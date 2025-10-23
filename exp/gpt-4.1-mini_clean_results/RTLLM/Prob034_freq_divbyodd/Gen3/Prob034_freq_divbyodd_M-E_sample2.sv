module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Compile-time check: NUM_DIV must be odd
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be odd, but is %0d", NUM_DIV);
        end
    end

    // Width of counter needed to count up to NUM_DIV-1
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    // 0 to NUM_DIV-1 counter incremented on both edges
    reg [CNT_WIDTH-1:0] cnt;

    // Increment counter and toggle clk_div on both clock edges
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_div <= 0;
        end else begin
            if (cnt == NUM_DIV - 1) begin
                cnt <= 0;
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset already done in posedge block, but synchronous reset replicated here
            cnt <= 0;
            clk_div <= 0;
        end else begin
            if (cnt == NUM_DIV - 1) begin
                cnt <= 0;
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

endmodule