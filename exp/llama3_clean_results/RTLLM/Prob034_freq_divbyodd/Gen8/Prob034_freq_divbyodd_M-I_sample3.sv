module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  logic clk,
    input  logic rst_n,
    output logic clk_div
);

logic clk_div1; // Clock divider for positive edges
logic clk_div2; // Clock divider for negative edges
logic [31:0] cnt1; // Counter for positive edges
logic [31:0] cnt2; // Counter for negative edges

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
    end else begin
        if (cnt1 < NUM_DIV - 1) begin
            cnt1 <= cnt1 + 1;
            if (cnt1 == (NUM_DIV - 1) / 2) begin
                clk_div1 <= ~clk_div1;
            end
        end else begin
            cnt1 <= 0;
        end
        
        if (cnt2 < NUM_DIV - 1) begin
            cnt2 <= cnt2 + 1;
            if (cnt2 == (NUM_DIV - 1) / 2 + (NUM_DIV - 1) / 2) begin
                clk_div2 <= ~clk_div2;
            end
        end else begin
            cnt2 <= 0;
        end
    end
end

assign clk_div = clk_div1 | clk_div2;

endmodule