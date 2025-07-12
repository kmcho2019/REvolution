module freq_diveven #
(
    parameter NUM_DIV = 4  // Must be even
)
(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Ensure NUM_DIV is even
    initial begin
        if (NUM_DIV % 2 != 0) begin
            $error("NUM_DIV parameter must be even, got %0d", NUM_DIV);
            $finish;
        end
    end

    // Calculate half period (number of clk cycles before toggling clk_div)
    localparam HALF_DIV = NUM_DIV >> 1;

    // Calculate required bits for the counter
    localparam CNT_WIDTH = $clog2(HALF_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
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