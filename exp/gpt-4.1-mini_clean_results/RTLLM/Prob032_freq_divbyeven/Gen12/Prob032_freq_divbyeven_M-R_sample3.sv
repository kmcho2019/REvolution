module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Check at compile time that NUM_DIV is even
    initial begin
        if (NUM_DIV % 2 != 0) begin
            $error("Parameter NUM_DIV must be an even number. Given: %0d", NUM_DIV);
        end
    end

    // Counter width calculated from NUM_DIV/2 (max count = NUM_DIV/2)
    localparam CNT_WIDTH = $clog2(NUM_DIV/2 + 1);

    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 0;
            clk_div <= 1'b0;
        end else begin
            if (cnt == (NUM_DIV/2)) begin
                cnt     <= 0;
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

endmodule