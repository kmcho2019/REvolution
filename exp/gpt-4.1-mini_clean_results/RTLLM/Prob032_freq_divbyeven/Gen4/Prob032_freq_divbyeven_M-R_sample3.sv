module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Local parameters
    localparam integer HALF_DIV = NUM_DIV / 2;
    localparam integer CNT_WIDTH = $clog2(HALF_DIV);

    // Compile-time check for even NUM_DIV
    generate
        if (NUM_DIV % 2 != 0) begin
            initial begin
                $error("NUM_DIV parameter must be even. Current value: %0d", NUM_DIV);
            end
        end
    endgenerate

    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= {CNT_WIDTH{1'b0}};
            clk_div <= 1'b0;
        end else begin
            if (cnt == HALF_DIV) begin
                cnt     <= {CNT_WIDTH{1'b0}};
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 1'b1;
            end
        end
    end

endmodule