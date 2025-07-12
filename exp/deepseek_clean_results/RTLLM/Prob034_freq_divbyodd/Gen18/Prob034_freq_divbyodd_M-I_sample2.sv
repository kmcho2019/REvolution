module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Parameter validation
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

reg [$clog2(NUM_DIV)-1:0] cnt1, cnt2;
reg clk_div1, clk_div2;
wire cnt1_full = (cnt1 == NUM_DIV-1);
wire cnt2_full = (cnt2 == NUM_DIV-1);
wire cnt1_half = (cnt1 == (NUM_DIV-1)/2);
wire cnt2_half = (cnt2 == (NUM_DIV-1)/2);

// Rising edge counter and clock
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt1 <= 0;
        clk_div1 <= 0;
    end else begin
        if (cnt1_full) begin
            cnt1 <= 0;
        end else begin
            cnt1 <= cnt1 + 1;
        end
        
        if (cnt1_half || cnt1_full) begin
            clk_div1 <= ~clk_div1;
        end
    end
end

// Falling edge counter and clock
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt2 <= 0;
        clk_div2 <= 0;
    end else begin
        if (cnt2_full) begin
            cnt2 <= 0;
        end else begin
            cnt2 <= cnt2 + 1;
        end
        
        if (cnt2_half || cnt2_full) begin
            clk_div2 <= ~clk_div2;
        end
    end
end

// Combined output clock
assign clk_div = clk_div1 | clk_div2;

endmodule