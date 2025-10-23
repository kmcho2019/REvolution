module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be an even number
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    reg [3:0] cnt;

    // Synthesis-time check for even NUM_DIV
    initial begin
        if (NUM_DIV % 2 != 0) begin
            $error("NUM_DIV parameter must be an even number. Current value: %0d", NUM_DIV);
        end
        if (NUM_DIV / 2 > 16) begin
            $warning("NUM_DIV/2 is greater than 16, counter width might be insufficient.");
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 4'd0;
            clk_div <= 1'b0;
        end else begin
            if (cnt == (NUM_DIV/2)) begin
                cnt     <= 4'd0;
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

endmodule