module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Assert NUM_DIV is even at compile time
    generate
        if (NUM_DIV % 2 != 0) begin
            initial $error("Parameter NUM_DIV must be even.");
        end
    endgenerate

    // Counter width fixed to 4 bits as per requirement
    reg [3:0] cnt;

    // Count limit: half of NUM_DIV
    localparam HALF_DIV = NUM_DIV / 2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 4'd0;
            clk_div <= 1'b0;
        end else begin
            if (cnt == HALF_DIV - 1) begin
                cnt <= 4'd0;
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

endmodule