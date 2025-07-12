module freq_diveven #(
    parameter integer NUM_DIV = 4 // Must be an even number
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Assert NUM_DIV is even at synthesis time (some tools support this)
    initial begin
        if (NUM_DIV % 2 != 0) begin
            $error("Parameter NUM_DIV must be even.");
        end
    end

    reg [3:0] cnt; // 4-bit counter

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt     <= 4'd0;
            clk_div <= 1'b0;
        end else begin
            if (cnt == (NUM_DIV/2 - 1)) begin
                cnt     <= 4'd0;
                clk_div <= ~clk_div; // Toggle output on half period
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

endmodule