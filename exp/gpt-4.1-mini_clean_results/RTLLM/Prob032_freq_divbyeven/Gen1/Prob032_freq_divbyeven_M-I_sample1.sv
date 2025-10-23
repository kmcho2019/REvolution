module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be an even number
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Calculate half division count for toggling clk_div
    localparam integer HALF_DIV = NUM_DIV / 2;

    // Calculate minimum width of counter to hold HALF_DIV-1
    localparam integer CNT_WIDTH = $clog2(HALF_DIV);

    // Counter to track clock cycles
    reg [CNT_WIDTH-1:0] cnt;

    // Check at elaboration/synthesis time that NUM_DIV is even
    initial begin
        if (NUM_DIV % 2 != 0) begin
            $error("Parameter NUM_DIV (%0d) must be an even number.", NUM_DIV);
        end
        if (NUM_DIV < 2) begin
            $error("Parameter NUM_DIV (%0d) must be >= 2.", NUM_DIV);
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= {CNT_WIDTH{1'b0}};
            clk_div <= 1'b0;
        end else begin
            if (cnt < HALF_DIV - 1) begin
                cnt <= cnt + 1'b1;
            end else begin
                cnt     <= {CNT_WIDTH{1'b0}};
                clk_div <= ~clk_div;
            end
        end
    end

endmodule