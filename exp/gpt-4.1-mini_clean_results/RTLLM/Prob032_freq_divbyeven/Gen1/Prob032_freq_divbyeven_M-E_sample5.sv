module freq_diveven #(
    parameter NUM_DIV = 6  // Must be an even number
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    reg [3:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 4'd0;
            clk_div <= 1'b0;
        end else begin
            if (cnt == NUM_DIV - 1) begin
                cnt     <= 4'd0;
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 1'b1;
                if (cnt == (NUM_DIV/2 - 1))
                    clk_div <= ~clk_div;
            end
        end
    end

endmodule