module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Compile-time check to ensure NUM_DIV is even
    initial begin
        if (NUM_DIV % 2 != 0) begin
            $error("Parameter NUM_DIV must be an even number. Given: %0d", NUM_DIV);
        end
    end

    // Counter width calculated from NUM_DIV/2 (max count = NUM_DIV/2 - 1)
    localparam CNT_WIDTH = $clog2(NUM_DIV/2);

    reg [CNT_WIDTH-1:0] cnt;
    reg toggle;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt    <= 0;
            toggle <= 1'b0;
        end else begin
            if (cnt == (NUM_DIV/2 - 1)) begin
                cnt    <= 0;
                toggle <= ~toggle;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

    // Combinational assignment for output clock from toggle register
    assign clk_div = toggle;

endmodule