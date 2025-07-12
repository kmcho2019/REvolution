module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be an even number
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Check parameter at compile time
    initial begin
        if (NUM_DIV % 2 != 0) begin
            $error("NUM_DIV must be even. Given: %0d", NUM_DIV);
        end
    end

    // Width of counter to count to half of NUM_DIV
    localparam integer HALF_DIV = NUM_DIV >> 1;
    localparam integer CNT_WIDTH = $clog2(HALF_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
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