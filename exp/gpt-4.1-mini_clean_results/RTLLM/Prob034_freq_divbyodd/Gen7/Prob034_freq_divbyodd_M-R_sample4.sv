module freq_divbyodd #(parameter NUM_DIV = 5) (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);
    // Validate parameter
    initial begin
        if (NUM_DIV < 3 || (NUM_DIV % 2) == 0) begin
            $error("NUM_DIV must be an odd number >= 3");
        end
    end

    localparam HALF_COUNT = (NUM_DIV - 1) / 2;
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    // Counter increments on every half clock cycle (both posedge and negedge of clk)
    reg [CNT_WIDTH-1:0] half_count;
    reg clk_div1;
    reg clk_div2;

    // Generate internal half_clk: toggle on negedge clk, register on posedge clk
    reg half_clk;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            half_clk <= 1'b0;
        else
            half_clk <= ~half_clk;
    end

    // Count half cycles on posedge clk, each increment corresponds to a half period
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            half_count <= 0;
            clk_div1 <= 1'b0;
            clk_div2 <= 1'b0;
        end else begin
            if (half_count == NUM_DIV - 1)
                half_count <= 0;
            else
                half_count <= half_count + 1;

            // Toggle clk_div1 at half_count == HALF_COUNT
            if (half_count == HALF_COUNT)
                clk_div1 <= ~clk_div1;

            // Toggle clk_div2 at half_count == NUM_DIV - 1
            if (half_count == NUM_DIV - 1)
                clk_div2 <= ~clk_div2;
        end
    end

    // Final divided clock is the OR of clk_div1 and clk_div2
    assign clk_div = clk_div1 | clk_div2;

endmodule