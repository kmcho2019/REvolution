```thought
To simplify the frequency divider, we can eliminate the PLL and instead use two counters, cnt1 and cnt2, to track the rising and falling edges of the clock. Each counter counts up to NUM_DIV - 1. We will also use two separate clock dividers, clk_div1 and clk_div2, for positive and negative edges of the clock, respectively. These are toggled when the counters reach half of NUM_DIV. The final divided clock output, clk_div, is derived by logically OR-ing clk_div1 and clk_div2 to account for both clock edges.
```

```verilog
module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  logic clk,
    input  logic rst_n,
    output logic clk_div
);

logic cnt1;
logic cnt2;
logic clk_div1;
logic clk_div2;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
    end else begin
        if (cnt1 == (NUM_DIV / 2)) begin
            cnt1 <= 0;
            clk_div1 <= ~clk_div1;
        end else begin
            cnt1 <= cnt1 + 1;
        end

        if (cnt2 == (NUM_DIV / 2)) begin
            cnt2 <= 0;
            clk_div2 <= ~clk_div2;
        end else begin
            cnt2 <= cnt2 + 1;
        end
    end
end

assign clk_div = clk_div1 | clk_div2;

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
