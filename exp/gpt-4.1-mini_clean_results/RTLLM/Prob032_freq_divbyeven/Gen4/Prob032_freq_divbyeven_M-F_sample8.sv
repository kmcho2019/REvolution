module freq_diveven #(
    parameter integer NUM_DIV = 6  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Calculate required counter width based on NUM_DIV
    localparam CNT_WIDTH = $clog2(NUM_DIV);
    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= {CNT_WIDTH{1'b0}};
            clk_div <= 1'b0;
        end else begin
            if (cnt == NUM_DIV - 1) begin
                cnt <= {CNT_WIDTH{1'b0}};
            end else begin
                cnt <= cnt + 1'b1;
            end

            // Toggle clk_div at half count to get 50% duty cycle output clock
            if (cnt == (NUM_DIV/2 - 1)) begin
                clk_div <= ~clk_div;
            end
        end
    end

endmodule