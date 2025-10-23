module freq_diveven #
(
    parameter integer NUM_DIV = 4  // Must be even and >= 2
)
(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Compile-time check for parameter validity
    initial begin
        if ((NUM_DIV < 2) || (NUM_DIV % 2) != 0) begin
            $fatal(1, "Parameter NUM_DIV must be even and >= 2, but got %0d", NUM_DIV);
        end
    end

    localparam integer CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= {CNT_WIDTH{1'b0}};
            clk_div <= 1'b0;
        end else begin
            if (cnt == NUM_DIV - 1)
                cnt <= {CNT_WIDTH{1'b0}};
            else
                cnt <= cnt + 1'b1;
            // clk_div high for first half, low for second half of count
            clk_div <= (cnt < (NUM_DIV >> 1)) ? 1'b1 : 1'b0;
        end
    end

endmodule