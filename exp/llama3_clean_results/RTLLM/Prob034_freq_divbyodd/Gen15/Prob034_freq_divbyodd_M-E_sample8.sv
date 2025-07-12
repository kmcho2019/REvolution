module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  logic clk,
    input  logic rst_n,
    output logic clk_div
);

logic [31:0] count;
logic [31:0] half_count;
logic div_clk;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        count <= 0;
        div_clk <= 1'b0;
    end else begin
        if (count == NUM_DIV - 1) begin
            div_clk <= ~div_clk;
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end
end

assign clk_div = div_clk;

endmodule