module freq_diveven #(
    parameter integer NUM_DIV = 4 // Must be even and >= 2
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Check parameter validity at elaboration time
    initial begin
        if (NUM_DIV < 2 || (NUM_DIV % 2) != 0) begin
            $error("NUM_DIV parameter (%0d) must be even and >= 2", NUM_DIV);
        end
    end

    localparam integer MAX_COUNT = NUM_DIV - 1;
    localparam integer HALF_COUNT = NUM_DIV >> 1;

    reg [3:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 4'd0;
            clk_div <= 1'b0;
        end else begin
            if (cnt == MAX_COUNT) begin
                cnt <= 4'd0;
            end else begin
                cnt <= cnt + 1'b1;
            end

            // Toggle clk_div at half period
            if (cnt == (HALF_COUNT - 1)) begin
                clk_div <= ~clk_div;
            end
        end
    end

endmodule