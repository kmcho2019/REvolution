module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

reg [31:0] cnt1;
reg [31:0] cnt2;
reg        clk_div1;
reg        clk_div2;

assign clk_div = clk_div1 | clk_div2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
    end else begin
        if (cnt1 == (NUM_DIV - 1) / 2) begin
            cnt1 <= 0;
            clk_div1 <= ~clk_div1;
        end else begin
            cnt1 <= cnt1 + 1;
        end
        
        if (cnt2 == (NUM_DIV - 1) / 2) begin
            cnt2 <= 0;
            clk_div2 <= ~clk_div2;
        end else begin
            cnt2 <= cnt2 + 1;
        end
    end
end

// cnt1 counts on the rising edge of the clock
always @(posedge clk) begin
    if (cnt1 == (NUM_DIV - 1)) begin
        cnt1 <= 0;
    end else begin
        cnt1 <= cnt1 + 1;
    end
end

// cnt2 counts on the falling edge of the clock
always @(negedge clk) begin
    if (cnt2 == (NUM_DIV - 1)) begin
        cnt2 <= 0;
    end else begin
        cnt2 <= cnt2 + 1;
    end
end

endmodule