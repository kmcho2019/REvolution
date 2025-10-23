module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    // Calculate half count value (integer division rounds down)
    localparam HALF_DIV = (NUM_DIV - 1) / 2;

    // Positive edge counter and clock
    reg [$clog2(NUM_DIV)-1:0] cnt1;
    reg clk_div1;

    // Negative edge counter and clock
    reg [$clog2(NUM_DIV)-1:0] cnt2;
    reg clk_div2;

    // Positive edge process
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 0;
        end
        else begin
            if (cnt1 == NUM_DIV - 1) begin
                cnt1 <= 0;
            end
            else begin
                cnt1 <= cnt1 + 1;
            end
            
            // Toggle at half point and wrap-around
            if (cnt1 == HALF_DIV || cnt1 == NUM_DIV - 1) begin
                clk_div1 <= ~clk_div1;
            end
        end
    end

    // Negative edge process
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= 0;
            clk_div2 <= 0;
        end
        else begin
            if (cnt2 == NUM_DIV - 1) begin
                cnt2 <= 0;
            end
            else begin
                cnt2 <= cnt2 + 1;
            end
            
            // Toggle at same points as posedge but phase shifted
            if (cnt2 == HALF_DIV || cnt2 == NUM_DIV - 1) begin
                clk_div2 <= ~clk_div2;
            end
        end
    end

    // Combine both clocks to create 50% duty cycle
    assign clk_div = clk_div1 | clk_div2;

endmodule