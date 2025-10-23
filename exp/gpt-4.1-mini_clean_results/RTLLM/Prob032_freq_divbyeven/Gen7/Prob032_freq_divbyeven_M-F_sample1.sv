module freq_divbyeven #(
    parameter NUM_DIV = 8  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Check NUM_DIV is even at compile time
    initial begin
        if (NUM_DIV == 0 || (NUM_DIV % 2) != 0) begin
            $error("NUM_DIV parameter must be a non-zero even number.");
            $finish;
        end
    end

    // Calculate width of counter
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    // Counter counts from 0 to NUM_DIV-1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_div <= 0;
        end else begin
            if (cnt == NUM_DIV - 1)
                cnt <= 0;
            else
                cnt <= cnt + 1'b1;
            // Assign clk_div as MSB of counter, which toggles every NUM_DIV/2 cycles
            clk_div <= cnt[CNT_WIDTH-1];
        end
    end

endmodule