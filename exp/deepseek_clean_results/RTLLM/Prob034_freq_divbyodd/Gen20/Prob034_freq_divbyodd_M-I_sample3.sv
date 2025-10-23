module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number >=3
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Parameter validation
initial begin
    if (NUM_DIV < 3 || NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number >= 3");
        $finish;
    end
end

localparam CNT_WIDTH = $clog2(NUM_DIV);
localparam HALF_CYCLE = (NUM_DIV - 1)/2;

reg [CNT_WIDTH-1:0] cnt1, cnt2;
reg clk_div1, clk_div2;

// Positive edge counter and divider
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt1 <= 0;
        clk_div1 <= 0;
    end else begin
        if (cnt1 == NUM_DIV - 1) begin
            cnt1 <= 0;
        end else begin
            cnt1 <= cnt1 + 1;
        end
        
        if (cnt1 == HALF_CYCLE) begin
            clk_div1 <= 1;
        end else if (cnt1 == NUM_DIV - 1) begin
            clk_div1 <= 0;
        end
    end
end

// Negative edge counter and divider
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt2 <= 0;
        clk_div2 <= 0;
    end else begin
        if (cnt2 == NUM_DIV - 1) begin
            cnt2 <= 0;
        end else begin
            cnt2 <= cnt2 + 1;
        end
        
        if (cnt2 == HALF_CYCLE) begin
            clk_div2 <= 1;
        end else if (cnt2 == NUM_DIV - 1) begin
            clk_div2 <= 0;
        end
    end
end

// Combine both dividers
assign clk_div = clk_div1 | clk_div2;

endmodule