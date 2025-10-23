module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  logic clk,
    input  logic rst_n,
    output logic clk_div
);

logic clk_div_int; // Internal clock divider
logic [31:0] cnt; // Counter

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        clk_div_int <= 1'b0;
    end else begin
        if (cnt < (NUM_DIV - 1) / 2) begin
            cnt <= cnt + 1;
        end else if (cnt < NUM_DIV - 1) begin
            cnt <= cnt + 1;
            if (cnt == (NUM_DIV - 1) / 2) begin
                clk_div_int <= ~clk_div_int;
            end
        end else begin
            cnt <= 0;
        end
    end
end

assign clk_div = clk_div_int;

endmodule