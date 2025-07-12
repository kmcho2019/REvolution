module freq_diveven #(
    parameter NUM_DIV = 4  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Check NUM_DIV parameter is even
    initial begin
        if (NUM_DIV % 2 != 0) begin
            $error("NUM_DIV parameter must be even.");
            $finish;
        end
    end

    // Calculate counter width for counting up to NUM_DIV/2 - 1
    localparam CNT_WIDTH = $clog2(NUM_DIV/2);

    reg [CNT_WIDTH-1:0] cnt;

    wire terminal_count = (cnt == (NUM_DIV/2 - 1));

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= {CNT_WIDTH{1'b0}};
            clk_div <= 1'b0;
        end else begin
            if (terminal_count) begin
                cnt <= {CNT_WIDTH{1'b0}};
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 1'b1;
            end
        end
    end

endmodule