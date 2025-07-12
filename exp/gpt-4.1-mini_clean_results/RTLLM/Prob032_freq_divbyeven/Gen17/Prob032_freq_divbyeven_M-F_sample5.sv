module freq_divbyeven #(
    parameter integer NUM_DIV = 4  // Must be even and <= 16
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Parameter checks at elaboration time
    initial begin
        if (NUM_DIV < 2 || (NUM_DIV % 2) != 0) begin
            $error("NUM_DIV (%0d) must be an even number >= 2", NUM_DIV);
        end
        if (NUM_DIV > 16) begin
            $error("NUM_DIV (%0d) must fit in 4-bit counter (max 16)", NUM_DIV);
        end
    end

    localparam integer COUNT_MAX    = NUM_DIV - 1;
    localparam integer TOGGLE_POINT = (NUM_DIV >> 1) - 1;

    reg [3:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 4'd0;
            clk_div <= 1'b0;
        end else begin
            if (cnt == TOGGLE_POINT) begin
                clk_div <= ~clk_div;
                cnt     <= 4'd0;
            end else begin
                cnt <= cnt + 1'b1;
            end
        end
    end

endmodule