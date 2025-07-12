module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  logic clk,
    input  logic rst_n,
    output logic clk_div
);

logic [1:0] state;
logic [$clog2(NUM_DIV):0] cnt;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0;
        cnt <= 0;
        clk_div <= 1'b0;
    end else begin
        cnt <= cnt + 1;
        
        if (cnt == (NUM_DIV - 1) / 2) begin
            state <= state == 0 ? 1 : 0;
            clk_div <= ~clk_div;
        end
        
        if (cnt == NUM_DIV - 1) begin
            cnt <= 0;
        end
    end
end

endmodule