module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Compile-time check for even NUM_DIV
    initial begin
        if (NUM_DIV % 2 != 0) begin
            $error("NUM_DIV must be even. Given: %0d", NUM_DIV);
        end
    end

    reg [3:0] cnt; // 4-bit counter as per problem statement

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 4'd0;
            clk_div <= 1'b0;
        end else begin
            if (cnt == (NUM_DIV/2 - 1)) begin
                cnt <= 4'd0;
                clk_div <= ~clk_div; // Toggle clk_div every half period
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

endmodule