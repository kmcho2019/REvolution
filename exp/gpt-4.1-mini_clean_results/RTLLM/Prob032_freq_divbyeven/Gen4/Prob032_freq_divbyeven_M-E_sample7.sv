module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Check parameter at compile time
    initial begin
        if (NUM_DIV % 2 != 0) begin
            $error("Parameter NUM_DIV (%0d) must be an even number.", NUM_DIV);
            $finish;
        end
    end

    // Calculate half period and counter width
    localparam integer HALF_DIV = NUM_DIV / 2;
    localparam integer CNT_WIDTH = $clog2(HALF_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 0;
            clk_div <= 1'b0;
        end else begin
            if (cnt == HALF_DIV - 1) begin
                cnt     <= 0;
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 1'b1;
            end
        end
    end

endmodule