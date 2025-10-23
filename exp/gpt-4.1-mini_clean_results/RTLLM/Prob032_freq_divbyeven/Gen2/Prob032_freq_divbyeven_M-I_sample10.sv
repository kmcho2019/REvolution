module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Calculate counter width based on NUM_DIV
    localparam integer CNT_WIDTH = $clog2(NUM_DIV/2);
    localparam integer HALF_DIV = NUM_DIV / 2;

    // Synthesis-time check for even NUM_DIV using generate block
    generate
        if (NUM_DIV % 2 != 0) begin
            initial begin
                $error("NUM_DIV parameter must be even. Current value: %0d", NUM_DIV);
            end
        end
    endgenerate

    reg [CNT_WIDTH-1:0] cnt;

    // Counter and clock divider logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= {CNT_WIDTH{1'b0}};
            clk_div <= 1'b0;
        end else if (cnt == HALF_DIV - 1) begin
            cnt     <= {CNT_WIDTH{1'b0}};
            clk_div <= ~clk_div;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end

endmodule