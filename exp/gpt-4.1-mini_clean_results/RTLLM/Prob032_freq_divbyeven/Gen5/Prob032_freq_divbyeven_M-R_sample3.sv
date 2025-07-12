module freq_diveven #
(
    parameter integer NUM_DIV = 4  // Must be even and >= 2
)
(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Compile-time check for even NUM_DIV
    initial begin
        if ((NUM_DIV < 2) || (NUM_DIV % 2) != 0) begin
            $fatal(1, "Parameter NUM_DIV must be even and >= 2, but got %0d", NUM_DIV);
        end
    end

    localparam integer HALF_DIV = NUM_DIV >> 1;
    localparam integer CNT_WIDTH = $clog2(HALF_DIV);

    reg [CNT_WIDTH-1:0] cnt;
    reg toggle_flag;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt         <= {CNT_WIDTH{1'b0}};
            clk_div     <= 1'b0;
            toggle_flag <= 1'b0;
        end else begin
            if (cnt == HALF_DIV - 1) begin
                cnt         <= {CNT_WIDTH{1'b0}};
                toggle_flag <= 1'b1;  // Signal to toggle clk_div next cycle
            end else begin
                cnt         <= cnt + 1'b1;
                toggle_flag <= 1'b0;
            end

            if (toggle_flag)
                clk_div <= ~clk_div;  // Toggle output clock at half division count
        end
    end

endmodule