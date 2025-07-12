module freq_diveven #
(
    parameter NUM_DIV = 6  // Must be even
)
(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Calculate required bit-width for counter based on NUM_DIV/2
    localparam CNT_WIDTH = $clog2(NUM_DIV >> 1);

    // Calculate half count value: NUM_DIV/2 - 1
    localparam HALF = (NUM_DIV >> 1) - 1;

    // Synthesis check to ensure NUM_DIV is even
    initial begin
        if (NUM_DIV % 2 != 0) begin
            $error("Parameter NUM_DIV must be even. Current value: %d", NUM_DIV);
            $finish;
        end
    end

    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= {CNT_WIDTH{1'b0}};
            clk_div <= 1'b0;
        end else if (cnt == HALF) begin
            cnt     <= {CNT_WIDTH{1'b0}};
            clk_div <= ~clk_div;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end

endmodule