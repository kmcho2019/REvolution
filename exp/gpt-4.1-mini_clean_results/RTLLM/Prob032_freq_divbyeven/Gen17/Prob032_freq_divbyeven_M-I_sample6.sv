module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be an even number
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Compile-time check for even NUM_DIV
    initial begin
        if (NUM_DIV % 2 != 0) begin
            $error("Parameter NUM_DIV must be even. Given: %0d", NUM_DIV);
        end
    end

    // Calculate counter width based on NUM_DIV
    localparam integer CNT_WIDTH = $clog2(NUM_DIV);

    // Half division count (toggle output every half count for 50% duty cycle)
    localparam integer HALF_DIV = NUM_DIV >> 1;

    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= {CNT_WIDTH{1'b0}};
            clk_div <= 1'b0;
        end else begin
            if (cnt == HALF_DIV) begin
                cnt     <= {CNT_WIDTH{1'b0}};
                clk_div <= ~clk_div;  // Toggle clk_div every half period
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

endmodule