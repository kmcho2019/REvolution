module freq_diveven #(
    parameter NUM_DIV = 4  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    reg [3:0] cnt;

    // Check that NUM_DIV is even at compile time
    initial begin
        if (NUM_DIV % 2 != 0) begin
            $error("NUM_DIV parameter must be an even number.");
            $finish;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 4'd0;
            clk_div <= 1'b0;
        end else begin
            if (cnt < (NUM_DIV/2 - 1)) begin
                cnt <= cnt + 1'b1;
            end else begin
                cnt     <= 4'd0;
                clk_div <= ~clk_div;
            end
        end
    end

endmodule