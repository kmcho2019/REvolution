module freq_diveven #
(
    parameter NUM_DIV = 4  // Must be an even number
)
(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Counter width sufficient for NUM_DIV/2 counting
    localparam CNT_WIDTH = 4;
    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 0;
            clk_div <= 0;
        end else begin
            if (cnt < (NUM_DIV/2 - 1)) begin
                cnt <= cnt + 1;
            end else begin
                cnt <= 0;
                clk_div <= ~clk_div;
            end
        end
    end

endmodule