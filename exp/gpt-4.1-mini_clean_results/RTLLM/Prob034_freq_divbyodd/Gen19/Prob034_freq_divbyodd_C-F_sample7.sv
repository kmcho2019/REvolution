module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,      // Active low asynchronous reset
    output wire clk_div
);

    // Compile-time check to ensure NUM_DIV is odd
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam integer HALF_DIV = NUM_DIV / 2;  // floor division

    // Minimum bits needed for counting up to NUM_DIV - 1
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    // Single counter counting 0 to NUM_DIV-1 on positive clock edge
    reg [CNT_WIDTH-1:0] cnt;
    // Delayed counter value for use in negedge domain
    reg [CNT_WIDTH-1:0] cnt_dly;

    // Clock divider registers toggled on positive and negative clock edges
    reg clk_div1, clk_div2;

    // Counter and clk_div1 toggling on positive edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt      <= {CNT_WIDTH{1'b0}};
            clk_div1 <= 1'b0;
        end else begin
            if (cnt == NUM_DIV - 1)
                cnt <= {CNT_WIDTH{1'b0}};
            else
                cnt <= cnt + 1'b1;

            // Toggle clk_div1 at count 0 and HALF_DIV for symmetry and 50% duty cycle
            if (cnt == 0 || cnt == HALF_DIV)
                clk_div1 <= ~clk_div1;
        end
    end

    // Delay counter value for negedge domain synchronization
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_dly <= {CNT_WIDTH{1'b0}};
        else
            cnt_dly <= cnt;
    end

    // clk_div2 toggled on negative clock edge based on delayed counter
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div2 <= 1'b0;
        end else begin
            // Toggle clk_div2 at count 0 and HALF_DIV (delayed) for symmetry
            if (cnt_dly == 0 || cnt_dly == HALF_DIV)
                clk_div2 <= ~clk_div2;
        end
    end

    // Output is logical OR of clk_div1 and clk_div2 to cover both edges
    assign clk_div = clk_div1 | clk_div2;

endmodule