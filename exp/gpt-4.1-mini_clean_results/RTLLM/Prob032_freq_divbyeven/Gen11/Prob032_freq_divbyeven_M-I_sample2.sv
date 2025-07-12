module freq_diveven #
(
    parameter integer NUM_DIV = 4  // Must be even and >= 2
)
(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Compile-time assertion: NUM_DIV must be even and >= 2
    localparam VALID_DIV = (NUM_DIV >= 2) && ((NUM_DIV % 2) == 0) ? 1 : 0;
    // Illegal vector width if invalid, causing elaboration error
    wire [VALID_DIV-1:0] check_valid_div = {VALID_DIV{1'b1}};

    // Half division count (number of clk cycles before toggling clk_div)
    localparam HALF_DIV = NUM_DIV >> 1;

    // 4-bit up-counter for counting clk cycles
    reg [3:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 0;
            clk_div <= 0;
        end else begin
            if (cnt == (HALF_DIV - 1)) begin
                cnt     <= 0;
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

endmodule