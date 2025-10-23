module freq_diveven #(
    parameter NUM_DIV = 8  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    reg [3:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 0;
            clk_div <= 0;
        end else if (cnt == (NUM_DIV/2 - 1)) begin
            cnt     <= 0;
            clk_div <= ~clk_div;
        end else begin
            cnt <= cnt + 1;
        end
    end

endmodule