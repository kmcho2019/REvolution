module freq_diveven #
(
    parameter NUM_DIV = 4  // Must be even and <= 16
)
(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Check NUM_DIV parameter validity
    initial begin
        if (NUM_DIV % 2 != 0) begin
            $error("NUM_DIV parameter must be even, got %0d", NUM_DIV);
            $finish;
        end
        if (NUM_DIV > 16) begin
            $error("NUM_DIV parameter must be <= 16 for 4-bit counter, got %0d", NUM_DIV);
            $finish;
        end
        if (NUM_DIV < 2) begin
            $error("NUM_DIV parameter must be >= 2, got %0d", NUM_DIV);
            $finish;
        end
    end

    reg [3:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 4'd0;
            clk_div <= 1'b0;
        end else begin
            if (cnt == NUM_DIV - 1) begin
                cnt     <= 4'd0;
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 4'd1;
            end
        end
    end

endmodule