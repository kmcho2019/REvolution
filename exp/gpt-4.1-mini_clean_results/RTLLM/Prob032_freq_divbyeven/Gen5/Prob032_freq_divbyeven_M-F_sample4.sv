module freq_divbyeven #(
    parameter NUM_DIV = 4  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    reg [3:0] cnt;  // 4-bit counter as requested

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt     <= 4'd0;
            clk_div <= 1'b0;
        end else begin
            if (cnt == (NUM_DIV/2 - 1)) begin
                cnt     <= 4'd0;
                clk_div <= ~clk_div;  // Toggle clk_div every half period
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

endmodule