module freq_diveven #(
    parameter NUM_DIV = 8  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    reg [3:0] down_cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            down_cnt <= NUM_DIV[3:0] >> 1;  // Initialize to NUM_DIV/2
            clk_div  <= 1'b0;
        end else begin
            if (down_cnt == 0) begin
                down_cnt <= NUM_DIV[3:0] >> 1;  // Reload counter
                clk_div  <= ~clk_div;            // Toggle output
            end else begin
                down_cnt <= down_cnt - 1;
            end
        end
    end

endmodule