module freq_diveven #(
    parameter NUM_DIV = 8  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    reg [3:0] cnt;

    localparam HALF_DIV = NUM_DIV >> 1;

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt     <= 4'd0;
            clk_div <= 1'b0;
        end else begin
            if (cnt == HALF_DIV) begin
                cnt     <= 4'd1;  // Start counting from 1 on next cycle
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

endmodule