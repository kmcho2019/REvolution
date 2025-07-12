module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

reg [31:0] cnt1;  // Counter for rising edge
reg [31:0] cnt2;  // Counter for falling edge
reg        clk_div1;  // Clock divider output for positive edge
reg        clk_div2;  // Clock divider output for negative edge
reg        prev_clk;  // Previous clock value

always @(posedge clk or negedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
        prev_clk <= 1'b0;
    end else begin
        // Update counters on rising and falling edges
        if (clk != prev_clk) begin
            if (clk) begin  // Rising edge
                cnt1 <= (cnt1 == (NUM_DIV - 1)) ? 0 : cnt1 + 1;
                if (cnt1 == (NUM_DIV / 2)) begin
                    clk_div1 <= ~clk_div1;
                end
            end else begin  // Falling edge
                cnt2 <= (cnt2 == (NUM_DIV - 1)) ? 0 : cnt2 + 1;
                if (cnt2 == (NUM_DIV / 2)) begin
                    clk_div2 <= ~clk_div2;
                end
            end
        end
        prev_clk <= clk;
    end
end

assign clk_div = clk_div1 | clk_div2;

endmodule