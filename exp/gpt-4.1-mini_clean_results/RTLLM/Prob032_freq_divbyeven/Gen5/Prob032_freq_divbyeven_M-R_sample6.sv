module freq_diveven #(
    parameter NUM_DIV = 4  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Counter width fixed at 4 bits as requested
    reg [3:0] cnt;

    // Half division count
    localparam HALF_DIV = NUM_DIV >> 1; // NUM_DIV / 2

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt     <= 0;
            clk_div <= 0;
        end else begin
            if (cnt == HALF_DIV - 1) begin
                cnt     <= 0;
                clk_div <= ~clk_div; // Toggle output clock
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

endmodule