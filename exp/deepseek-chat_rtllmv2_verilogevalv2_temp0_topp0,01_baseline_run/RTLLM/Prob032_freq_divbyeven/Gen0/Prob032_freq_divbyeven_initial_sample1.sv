module freq_diveven #(
    parameter NUM_DIV = 4  // Must be even number
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

// Check if NUM_DIV is even
generate
    if (NUM_DIV % 2 != 0) begin
        initial $error("NUM_DIV must be an even number");
    end
endgenerate

reg [3:0] cnt;  // 4-bit counter (supports up to div-by-32)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'b0;
        clk_div <= 1'b0;
    end
    else begin
        if (cnt == (NUM_DIV/2 - 1)) begin
            cnt <= 4'b0;
            clk_div <= ~clk_div;
        end
        else begin
            cnt <= cnt + 1'b1;
        end
    end
end

endmodule