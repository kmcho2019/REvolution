module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  logic clk,
    input  logic rst_n,
    output logic clk_div
);

logic [$clog2(NUM_DIV):0] counter;
logic clk_div_int;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        clk_div_int <= 1'b0;
    end else begin
        if (counter == NUM_DIV - 1) begin
            counter <= 0;
            clk_div_int <= ~clk_div_int;
        end else begin
            counter <= counter + 1;
        end
    end
end

assign clk_div = clk_div_int;

endmodule