module freq_diveven #(
    parameter NUM_DIV = 4  // must be even number
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Compile-time check that NUM_DIV is even
    initial begin
        if (NUM_DIV == 0 || (NUM_DIV % 2) != 0) begin
            $error("NUM_DIV parameter must be a non-zero even number");
            $finish;
        end
    end

    // Calculate counter width to count up to NUM_DIV/2 - 1
    localparam CNT_WIDTH = $clog2(NUM_DIV/2);

    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt     <= 0;
            clk_div <= 0;
        end else begin
            if (cnt == (NUM_DIV/2 - 1)) begin
                cnt     <= 0;
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

endmodule