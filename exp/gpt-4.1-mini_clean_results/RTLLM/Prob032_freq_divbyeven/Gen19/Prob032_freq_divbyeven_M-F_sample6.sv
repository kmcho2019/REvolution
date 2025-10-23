module freq_divbyeven #(
    parameter integer NUM_DIV = 4  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Compile-time check for even NUM_DIV
    initial begin
        if (NUM_DIV % 2 != 0) begin
            $error("Error: NUM_DIV parameter must be even. Given: %0d", NUM_DIV);
        end
    end

    localparam integer CNT_WIDTH = $clog2(NUM_DIV);
    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 0;
            clk_div <= 0;
        end else begin
            if (cnt == NUM_DIV - 1) begin
                cnt <= 0;
                clk_div <= ~clk_div;  // Toggle at the end of the full cycle
            end else begin
                cnt <= cnt + 1;
                if (cnt == (NUM_DIV >> 1) - 1) begin
                    clk_div <= ~clk_div; // Toggle in the middle of the cycle
                end
            end
        end
    end

endmodule