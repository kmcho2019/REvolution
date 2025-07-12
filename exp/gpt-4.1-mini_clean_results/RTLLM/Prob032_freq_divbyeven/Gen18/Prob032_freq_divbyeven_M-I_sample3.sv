module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be an even number
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Compile-time parameter check using generate block
    generate
        if (NUM_DIV % 2 != 0) begin
            // This synthesis directive is vendor-dependent;
            // for generic tools, this will produce an error
            initial begin
                $error("Parameter NUM_DIV must be even. Given: %0d", NUM_DIV);
            end
        end
    endgenerate

    // Half division factor
    localparam integer HALF_DIV = NUM_DIV >> 1;

    // Calculate minimum counter width to count up to HALF_DIV - 1
    localparam integer CNT_WIDTH = $clog2(HALF_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    // Synchronous reset implementation for better timing closure
    always @(posedge clk) begin
        if (!rst_n) begin
            cnt     <= 0;
            clk_div <= 0;
        end else begin
            if (cnt == HALF_DIV - 1) begin
                cnt     <= 0;
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

endmodule