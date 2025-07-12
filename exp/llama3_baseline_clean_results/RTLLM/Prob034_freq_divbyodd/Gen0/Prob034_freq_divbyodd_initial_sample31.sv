module freq_divbyodd #(
    parameter NUM_DIV = 5
)(
    input  logic clk,
    input  logic rst_n,
    output logic clk_div
);

logic [31:0] cnt1, cnt2;
logic        clk_div1, clk_div2;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
    end else begin
        if (cnt1 == (NUM_DIV - 1) / 2) begin
            clk_div1 <= ~clk_div1;
            cnt1 <= 0;
        end else begin
            cnt1 <= cnt1 + 1;
        end

        if (cnt2 == (NUM_DIV - 1) / 2) begin
            clk_div2 <= ~clk_div2;
            cnt2 <= 0;
        end else begin
            cnt2 <= cnt2 + 1;
        end
    end
end

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else begin
        if (clk_div1 || clk_div2) begin
            clk_div <= 1'b1;
        end else begin
            clk_div <= 1'b0;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // do nothing, since always_ff is used for clk_div1, clk_div2, cnt1, cnt2, and clk_div
    end else begin
        // cnt1 only increments on posedge
        if (clk == 1'b1) begin
            cnt1 <= cnt1 + 1;
        end else begin
            // cnt2 only increments on negedge
            cnt2 <= cnt2 + 1;
        end
    end
end

endmodule