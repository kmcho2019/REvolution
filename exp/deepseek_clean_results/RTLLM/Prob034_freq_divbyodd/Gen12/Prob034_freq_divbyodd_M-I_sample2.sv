module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number >= 3
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Parameter validation
initial begin
    if (NUM_DIV % 2 == 0 || NUM_DIV < 3) begin
        $error("NUM_DIV must be an odd number >= 3");
        $finish;
    end
end

localparam CNT_WIDTH = $clog2(NUM_DIV);
localparam HALF_DIV = (NUM_DIV-1)/2;

// Positive edge counter and clock
reg [CNT_WIDTH-1:0] cnt_p;
reg clk_div_p;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_p <= 0;
        clk_div_p <= 0;
    end else begin
        if (cnt_p == NUM_DIV-1) begin
            cnt_p <= 0;
            clk_div_p <= ~clk_div_p;
        end else begin
            cnt_p <= cnt_p + 1;
            if (cnt_p == HALF_DIV-1)
                clk_div_p <= ~clk_div_p;
        end
    end
end

// Negative edge counter and clock
reg [CNT_WIDTH-1:0] cnt_n;
reg clk_div_n;

always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_n <= 0;
        clk_div_n <= 0;
    end else begin
        if (cnt_n == NUM_DIV-1) begin
            cnt_n <= 0;
            clk_div_n <= ~clk_div_n;
        end else begin
            cnt_n <= cnt_n + 1;
            if (cnt_n == HALF_DIV-1)
                clk_div_n <= ~clk_div_n;
        end
    end
end

// Combine both phase clocks with OR
assign clk_div = clk_div_p | clk_div_n;

endmodule