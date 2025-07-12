module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // On posedge clk: count 4 cycles, toggle clk_pos
    reg [1:0] cnt_pos;       // Counts 0..3 for 4 cycles
    reg       clk_pos;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos <= 2'd0;
            clk_pos <= 1'b0;
        end else begin
            if (cnt_pos == 2'd3) begin
                cnt_pos <= 2'd0;
                clk_pos <= ~clk_pos;
            end else begin
                cnt_pos <= cnt_pos + 2'd1;
            end
        end
    end

    // On negedge clk: count 3 cycles, toggle clk_neg
    reg [1:0] cnt_neg;       // Counts 0..2 for 3 cycles
    reg       clk_neg;

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg <= 2'd0;
            clk_neg <= 1'b0;
        end else begin
            if (cnt_neg == 2'd2) begin
                cnt_neg <= 2'd0;
                clk_neg <= ~clk_neg;
            end else begin
                cnt_neg <= cnt_neg + 2'd1;
            end
        end
    end

    // OR the two phase-shifted clocks to get fractional divided clock output
    assign clk_div = clk_pos | clk_neg;

endmodule