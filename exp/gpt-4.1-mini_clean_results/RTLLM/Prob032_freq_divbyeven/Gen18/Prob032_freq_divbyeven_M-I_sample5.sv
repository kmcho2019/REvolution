module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be an even number >= 2
)(
    input  wire clk,
    input  wire rst_n,    // Active-low synchronous reset
    output reg  clk_div
);

    // Compile-time check: NUM_DIV must be even and >= 2
    initial begin
        if ((NUM_DIV < 2) || (NUM_DIV % 2 != 0)) begin
            $error("Parameter NUM_DIV must be an even number >= 2. Given: %0d", NUM_DIV);
        end
    end

    // Half division factor (toggle clk_div every HALF_DIV cycles)
    localparam integer HALF_DIV = NUM_DIV >> 1;

    // Calculate minimum counter width to count up to HALF_DIV - 1
    localparam integer CNT_WIDTH = (HALF_DIV <= 1) ? 1 : $clog2(HALF_DIV);

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