module freq_diveven #(
    parameter integer NUM_DIV = 4 // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Compile-time check for even NUM_DIV (some tools support this)
    initial begin
        if (NUM_DIV % 2 != 0) begin
            $error("NUM_DIV must be an even number.");
        end
    end

    // Calculate counter bit width based on NUM_DIV
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= {CNT_WIDTH{1'b0}};
            clk_div <= 1'b0;
        end else begin
            if (cnt == NUM_DIV - 1) begin
                cnt     <= {CNT_WIDTH{1'b0}};
                clk_div <= ~clk_div; // Toggle output at full cycle count
            end else begin
                cnt <= cnt + 1'b1;
            end
        end
    end

endmodule