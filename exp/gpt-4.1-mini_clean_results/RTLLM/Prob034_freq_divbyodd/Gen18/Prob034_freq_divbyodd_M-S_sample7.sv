module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,     // Active low asynchronous reset
    output wire clk_div
);

    // Check parameter oddness at compile time
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam integer HALF_DIV = NUM_DIV / 2;  // floor division

    // Width for counters
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    // Counters and clock dividers for posedge and negedge
    reg [CNT_WIDTH-1:0] cnt1;
    reg clk_div1;

    reg [CNT_WIDTH-1:0] cnt2;
    reg clk_div2;

    // Positive edge domain counter and clk_div1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1     <= {CNT_WIDTH{1'b0}};
            clk_div1 <= 1'b0;
        end else begin
            if (cnt1 == NUM_DIV - 1)
                cnt1 <= {CNT_WIDTH{1'b0}};
            else
                cnt1 <= cnt1 + 1'b1;

            if (cnt1 == 0)
                clk_div1 <= 1'b1;
            else if (cnt1 == HALF_DIV)
                clk_div1 <= 1'b0;
        end
    end

    // Negative edge domain counter and clk_div2
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2     <= {CNT_WIDTH{1'b0}};
            clk_div2 <= 1'b0;
        end else begin
            if (cnt2 == NUM_DIV - 1)
                cnt2 <= {CNT_WIDTH{1'b0}};
            else
                cnt2 <= cnt2 + 1'b1;

            if (cnt2 == 0)
                clk_div2 <= 1'b1;
            else if (cnt2 == HALF_DIV)
                clk_div2 <= 1'b0;
        end
    end

    // Output is OR of posedge and negedge dividers
    assign clk_div = clk_div1 | clk_div2;

endmodule