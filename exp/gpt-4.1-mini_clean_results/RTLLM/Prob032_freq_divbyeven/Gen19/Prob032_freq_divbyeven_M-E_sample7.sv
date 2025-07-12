module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Compile-time check: NUM_DIV must be even
    initial begin
        if (NUM_DIV % 2 != 0) begin
            $error("Parameter NUM_DIV (%0d) must be even.", NUM_DIV);
        end
    end

    localparam integer HALF_DIV = NUM_DIV / 2;
    localparam integer CNT_WIDTH = $clog2(HALF_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt     <= {CNT_WIDTH{1'b0}};
            clk_div <= 1'b0;
        end else begin
            if (cnt == HALF_DIV - 1) begin
                cnt     <= {CNT_WIDTH{1'b0}};
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 1'b1;
            end
        end
    end

endmodule