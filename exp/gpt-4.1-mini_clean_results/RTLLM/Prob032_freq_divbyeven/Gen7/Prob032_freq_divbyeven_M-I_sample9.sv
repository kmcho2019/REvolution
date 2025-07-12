module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Synthesis-time check for even NUM_DIV using generate-if
    // This will cause synthesis tools to flag error if NUM_DIV is not even
    generate
        if (NUM_DIV % 2 != 0) begin
            initial begin
                $error("NUM_DIV parameter must be even.");
            end
        end
    endgenerate

    // Width of the counter: at least 1 bit
    localparam integer HALF_DIV = NUM_DIV / 2;
    localparam integer CNT_WIDTH = (HALF_DIV > 1) ? $clog2(HALF_DIV) : 1;

    reg [CNT_WIDTH-1:0] cnt;

    // Synchronous reset and counting logic
    always @(posedge clk) begin
        if (!rst_n) begin
            cnt <= {CNT_WIDTH{1'b0}};
            clk_div <= 1'b0;
        end else begin
            if (cnt == HALF_DIV - 1) begin
                cnt <= {CNT_WIDTH{1'b0}};
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 1'b1;
            end
        end
    end

endmodule