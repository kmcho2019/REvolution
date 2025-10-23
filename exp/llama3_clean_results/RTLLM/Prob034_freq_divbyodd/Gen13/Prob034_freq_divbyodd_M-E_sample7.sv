module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  logic clk,
    input  logic rst_n,
    output logic clk_div
);

logic clk_int;
logic clk_en;
logic [$clog2(NUM_DIV-1):0] cnt;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        clk_int <= 1'b0;
        clk_en <= 1'b0;
    end else begin
        if (cnt == NUM_DIV - 1) begin
            cnt <= 0;
            clk_int <= ~clk_int;
            clk_en <= ~clk_en;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

assign clk_div = clk_int;

always_comb begin
    if (cnt == (NUM_DIV / 2) - 1) begin
        clk_en = 1'b1;
    end else begin
        clk_en = 1'b0;
    end
end

// Clock gating
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else if (clk_en) begin
        clk_div <= clk_int;
    end else begin
        clk_div <= 1'b0;
    end
end

endmodule