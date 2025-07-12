module freq_diveven #
(
    parameter integer NUM_DIV = 4  // Must be even and >= 2
)
(
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Compile-time check for NUM_DIV validity
    localparam VALID_DIV = (NUM_DIV >= 2) && ((NUM_DIV % 2) == 0) ? 1 : 0;
    wire [VALID_DIV-1:0] check_valid_div = {VALID_DIV{1'b1}};

    localparam HALF_DIV = NUM_DIV >> 1;

    // 4-bit counter for counting clock cycles up to HALF_DIV-1
    reg [3:0] cnt;

    // Internal toggle register that flips every HALF_DIV cycles
    reg toggle;

    // Counter process: increments on each clk, resets to 0 when reaching HALF_DIV-1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 4'd0;
        end else begin
            if (cnt == (HALF_DIV - 1))
                cnt <= 4'd0;
            else
                cnt <= cnt + 4'd1;
        end
    end

    // Toggle process: flips toggle bit when cnt resets to 0
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            toggle <= 1'b0;
        end else begin
            if (cnt == (HALF_DIV - 1))
                toggle <= ~toggle;
        end
    end

    // Output clock driven by toggle register
    assign clk_div = toggle;

endmodule