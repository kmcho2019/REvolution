module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even and <= 32
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Compile-time check for even NUM_DIV
    initial begin
        if (NUM_DIV % 2 != 0) begin
            $error("NUM_DIV must be an even number.");
        end
        if (NUM_DIV > 32) begin
            $error("NUM_DIV must be <= 32 to fit counter width.");
        end
    end

    reg [3:0] cnt; // 4-bit counter as specified

    // Half period count (NUM_DIV/2 - 1)
    localparam HALF_CNT_MAX = (NUM_DIV >> 1) - 1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 4'd0;
            clk_div <= 1'b0;
        end else begin
            if (cnt == HALF_CNT_MAX) begin
                cnt     <= 4'd0;
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 4'd1;
            end
        end
    end

endmodule