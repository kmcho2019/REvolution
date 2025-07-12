module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Validate parameter
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

localparam CNT_WIDTH = $clog2(NUM_DIV);
localparam HALF_CYCLE = (NUM_DIV - 1)/2;

// Positive edge domain
reg [CNT_WIDTH-1:0] cnt1;
reg clk_div1;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt1 <= 0;
        clk_div1 <= 0;
    end else begin
        if (cnt1 == NUM_DIV - 1) begin
            cnt1 <= 0;
            clk_div1 <= ~clk_div1;
        end else begin
            cnt1 <= cnt1 + 1;
            if (cnt1 == HALF_CYCLE - 1) begin
                clk_div1 <= ~clk_div1;
            end
        end
    end
end

// Negative edge domain
reg [CNT_WIDTH-1:0] cnt2;
reg clk_div2;

always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt2 <= 0;
        clk_div2 <= 0;
    end else begin
        if (cnt2 == NUM_DIV - 1) begin
            cnt2 <= 0;
            clk_div2 <= ~clk_div2;
        end else begin
            cnt2 <= cnt2 + 1;
            if (cnt2 == HALF_CYCLE - 1) begin
                clk_div2 <= ~clk_div2;
            end
        end
    end
end

// Combine both edge clocks
assign clk_div = clk_div1 | clk_div2;

endmodule