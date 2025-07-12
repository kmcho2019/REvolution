module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  logic clk,
    input  logic rst_n,
    output logic clk_div
);

logic [$clog2(NUM_DIV-1):0] cnt;
logic clk_div_int;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        clk_div_int <= 1'b0;
    end else begin
        if (cnt == (NUM_DIV - 1)) begin
            cnt <= 0;
            if (NUM_DIV > 1) begin
                clk_div_int <= ~clk_div_int;
            end
        end else begin
            cnt <= cnt + 1;
        end
    end
end

assign clk_div = clk_div_int;

endmodule