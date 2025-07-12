module freq_diveven #
(
    parameter integer NUM_DIV = 4  // Must be even, >= 2
)
(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Compile-time assertion: NUM_DIV must be even and >= 2
    initial begin
        if (NUM_DIV < 2 || (NUM_DIV % 2) != 0) begin
            $error("Parameter NUM_DIV must be an even number >= 2. Current value: %0d", NUM_DIV);
            $finish;
        end
    end

    // Calculate bit width needed for counter: ceil(log2(NUM_DIV/2))
    localparam integer HALF_DIV = NUM_DIV / 2;
    localparam integer CNT_WIDTH = $clog2(HALF_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= {CNT_WIDTH{1'b0}};
            clk_div <= 1'b0;
        end else if (cnt == HALF_DIV - 1) begin
            cnt     <= {CNT_WIDTH{1'b0}};
            clk_div <= ~clk_div;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end

endmodule