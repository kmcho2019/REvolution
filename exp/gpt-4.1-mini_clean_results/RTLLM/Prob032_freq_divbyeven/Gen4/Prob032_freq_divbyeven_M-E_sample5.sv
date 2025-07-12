module freq_diveven #(
    parameter NUM_DIV = 4  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Calculate counter width based on NUM_DIV
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    // Synchronous reset and counting logic
    always @(posedge clk) begin
        if (!rst_n) begin
            cnt     <= 0;
            clk_div <= 0;
        end else begin
            if (cnt == NUM_DIV - 1) begin
                cnt     <= 0;
                clk_div <= 0;           // Set low at the end of the cycle
            end else begin
                cnt <= cnt + 1;
                if (cnt == (NUM_DIV / 2) - 1)
                    clk_div <= 1;       // Set high at half period
            end
        end
    end

endmodule