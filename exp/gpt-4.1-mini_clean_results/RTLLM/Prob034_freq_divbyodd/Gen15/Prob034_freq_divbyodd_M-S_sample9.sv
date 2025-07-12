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
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt;
    reg clk_div1, clk_div2;

    // Counter and clk_div1 logic on positive edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt      <= 0;
            clk_div1 <= 1'b0;
        end else begin
            if (cnt == NUM_DIV - 1)
                cnt <= 0;
            else
                cnt <= cnt + 1;

            if (cnt == 0)
                clk_div1 <= 1'b1;
            else if (cnt == HALF_DIV)
                clk_div1 <= 1'b0;
        end
    end

    // clk_div2 logic on negative edge using same counter value
    // Sample counter value at negedge clk is approximated by posedge counter value (slight timing offset)
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div2 <= 1'b0;
        end else begin
            // Use same count values as clk_div1 to set and clear clk_div2 on negedge clk
            // To align clk_div2 with clk_div1 shifted by half clock
            if (cnt == 0)
                clk_div2 <= 1'b1;
            else if (cnt == HALF_DIV)
                clk_div2 <= 1'b0;
        end
    end

    assign clk_div = clk_div1 | clk_div2;

endmodule