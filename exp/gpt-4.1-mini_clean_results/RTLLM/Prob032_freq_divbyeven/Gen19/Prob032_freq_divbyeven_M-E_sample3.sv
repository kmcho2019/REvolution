module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even and >= 2
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Assert NUM_DIV is even and >= 2 at elaboration time
    initial begin
        if (NUM_DIV < 2 || (NUM_DIV % 2) != 0) begin
            $error("NUM_DIV parameter (%0d) must be even and >= 2", NUM_DIV);
        end
    end

    // Counter width fixed at 4 bits per spec
    reg [3:0] cnt;

    // Calculate half period (NUM_DIV/2 - 1) constant
    localparam integer HALF_DIV_MINUS_ONE = (NUM_DIV >> 1) - 1;

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt <= 4'd0;
            clk_div <= 1'b0;
        end else begin
            if (cnt == HALF_DIV_MINUS_ONE) begin
                cnt <= 4'd0;
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 4'd1;
            end
        end
    end

endmodule