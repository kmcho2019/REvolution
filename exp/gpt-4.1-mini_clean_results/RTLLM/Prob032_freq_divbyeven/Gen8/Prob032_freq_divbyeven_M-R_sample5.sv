module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even and >= 2
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Parameter check at elaboration time
    initial begin
        if ((NUM_DIV < 2) || (NUM_DIV % 2 != 0)) begin
            $fatal("Error: NUM_DIV parameter must be even and >= 2. Given: %0d", NUM_DIV);
        end
    end

    localparam integer HALF_DIV = NUM_DIV >> 1;
    localparam integer CNT_WIDTH = (HALF_DIV > 1) ? $clog2(HALF_DIV) : 1;

    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt     <= 0;
            clk_div <= 0;
        end else begin
            if (cnt == HALF_DIV - 1) begin
                cnt     <= 0;
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 1'b1;
            end
        end
    end

endmodule