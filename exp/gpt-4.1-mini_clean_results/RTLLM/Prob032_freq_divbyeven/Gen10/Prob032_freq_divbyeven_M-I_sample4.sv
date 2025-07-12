module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even and >= 2
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Compile-time parameter check for valid NUM_DIV
    generate
        if (NUM_DIV < 2 || (NUM_DIV % 2) != 0) begin
            initial begin
                $error("Parameter NUM_DIV must be an even number >= 2 (current: %0d)", NUM_DIV);
                $finish;
            end
        end
    endgenerate

    localparam integer HALF_DIV = NUM_DIV >> 1;  // Divide by half for toggling

    // Calculate counter width with minimum 1 bit
    localparam integer CNT_WIDTH = (HALF_DIV > 1) ? $clog2(HALF_DIV) : 1;

    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= {CNT_WIDTH{1'b0}};
            clk_div <= 1'b0;
        end else if (cnt == HALF_DIV - 1) begin
            cnt     <= {CNT_WIDTH{1'b0}};
            clk_div <= ~clk_div; // Toggle output every HALF_DIV cycles
        end else begin
            cnt <= cnt + 1'b1;
        end
    end

endmodule