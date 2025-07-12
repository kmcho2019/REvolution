module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Positive edge counter: counts 0..3 (4 cycles)
    reg [1:0] cnt_pos;
    reg       clk_div_pos;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos     <= 2'd0;
            clk_div_pos <= 1'b0;
        end else begin
            if (cnt_pos == 2'd3) begin
                cnt_pos     <= 2'd0;
                clk_div_pos <= 1'b1;
            end else begin
                cnt_pos     <= cnt_pos + 2'd1;
                clk_div_pos <= (cnt_pos < 2'd3) ? 1'b1 : 1'b0; // High for counts 0..3
            end
        end
    end

    // Negative edge counter: counts 0..2 (3 cycles)
    reg [1:0] cnt_neg;
    reg       clk_div_neg;

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg     <= 2'd0;
            clk_div_neg <= 1'b0;
        end else begin
            if (cnt_neg == 2'd2) begin
                cnt_neg     <= 2'd0;
                clk_div_neg <= 1'b1;
            end else begin
                cnt_neg     <= cnt_neg + 2'd1;
                clk_div_neg <= (cnt_neg < 2'd2) ? 1'b1 : 1'b0; // High for counts 0..2
            end
        end
    end

    // Combine the two clock halves by OR
    assign clk_div = clk_div_pos | clk_div_neg;

endmodule