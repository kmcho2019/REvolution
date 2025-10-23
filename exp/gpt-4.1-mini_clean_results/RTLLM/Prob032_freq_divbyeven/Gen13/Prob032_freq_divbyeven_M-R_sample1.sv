module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be an even number >= 2
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

    localparam integer HALF_DIV = NUM_DIV >> 1;

    // 4-bit counter as per specification
    reg [3:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 4'd0;
            clk_div <= 1'b0;
        end else begin
            if (cnt == (HALF_DIV - 1)) begin
                cnt     <= 4'd0;
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 1'b1;
            end
        end
    end

endmodule