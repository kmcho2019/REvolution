module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  logic clk,
    input  logic rst_n,
    output logic clk_div
);

logic [$clog2(NUM_DIV-1):0] cnt;
logic [1:0] phase;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        phase <= 0;
    end else begin
        if (cnt == NUM_DIV - 1) begin
            cnt <= 0;
            phase <= phase + 1;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

assign clk_div = (phase == 1);

endmodule