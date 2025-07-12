module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,      // Active low reset, now used synchronously
    output wire clk_div
);

    // Compile-time check to ensure NUM_DIV is odd
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam integer HALF_DIV = NUM_DIV / 2;  // floor division
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    // Counter counting 0 to NUM_DIV-1 on posedge clk
    reg [CNT_WIDTH-1:0] cnt;
    reg [CNT_WIDTH-1:0] cnt_dly;

    reg clk_div1, clk_div2;

    // Synchronous reset and counter with toggle on posedge clk
    always @(posedge clk) begin
        if (!rst_n) begin
            cnt      <= {CNT_WIDTH{1'b0}};
            clk_div1 <= 1'b0;
            cnt_dly  <= {CNT_WIDTH{1'b0}};
        end else begin
            // Counter modulo NUM_DIV
            if (cnt == NUM_DIV - 1)
                cnt <= {CNT_WIDTH{1'b0}};
            else
                cnt <= cnt + 1'b1;

            // Toggle clk_div1 only at count 0 or HALF_DIV (single condition)
            if (cnt == 0 || cnt == HALF_DIV)
                clk_div1 <= ~clk_div1;

            // Update delayed counter for negedge domain
            cnt_dly <= cnt;
        end
    end

    // clk_div2 toggled on negedge clk with synchronous reset
    always @(negedge clk) begin
        if (!rst_n) begin
            clk_div2 <= 1'b0;
        end else begin
            // Toggle clk_div2 only at delayed count 0 or HALF_DIV for symmetry
            if (cnt_dly == 0 || cnt_dly == HALF_DIV)
                clk_div2 <= ~clk_div2;
        end
    end

    // Output clock combines posedge and negedge divided clocks
    assign clk_div = clk_div1 | clk_div2;

endmodule