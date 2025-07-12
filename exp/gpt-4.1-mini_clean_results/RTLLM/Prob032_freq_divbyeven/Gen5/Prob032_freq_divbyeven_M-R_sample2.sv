module freq_diveven #(
    parameter NUM_DIV = 6  // Must be even and > 0
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    localparam HALF_DIV = NUM_DIV >> 1;
    localparam CNT_WIDTH = $clog2(HALF_DIV);

    // Synthesis-time assertion for NUM_DIV validity
    initial begin
        if ((NUM_DIV == 0) || (NUM_DIV % 2 != 0)) begin
            $error("Parameter NUM_DIV must be a non-zero even number");
            $finish;
        end
    end

    reg [CNT_WIDTH-1:0] cnt;

    wire terminal_count = (cnt == HALF_DIV - 1);
    wire [CNT_WIDTH-1:0] cnt_next = terminal_count ? {CNT_WIDTH{1'b0}} : (cnt + 1'b1);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= {CNT_WIDTH{1'b0}};
            clk_div <= 1'b0;
        end else begin
            cnt <= cnt_next;
            if (terminal_count)
                clk_div <= ~clk_div;
        end
    end

endmodule