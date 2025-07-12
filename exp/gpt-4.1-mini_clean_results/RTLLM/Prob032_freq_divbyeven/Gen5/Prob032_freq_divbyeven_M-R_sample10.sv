module freq_diveven #(
    parameter integer NUM_DIV = 6  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Calculate counter width based on NUM_DIV
    localparam CNT_WIDTH = (NUM_DIV > 1) ? $clog2(NUM_DIV) : 1;
    reg [CNT_WIDTH-1:0] cnt;

    // Toggle enable pulse
    wire toggle_pulse;

    // Generate toggle pulse when counter reaches half period - 1
    assign toggle_pulse = (cnt == (NUM_DIV/2 - 1));

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= {CNT_WIDTH{1'b0}};
            clk_div <= 1'b0;
        end else begin
            // Counter logic
            if (cnt == NUM_DIV - 1)
                cnt <= {CNT_WIDTH{1'b0}};
            else
                cnt <= cnt + 1'b1;

            // Toggle clk_div on toggle_pulse
            if (toggle_pulse)
                clk_div <= ~clk_div;
        end
    end

endmodule