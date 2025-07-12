module freq_diveven #(
    parameter NUM_DIV = 4  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Compile-time check that NUM_DIV is even
    initial begin
        if (NUM_DIV % 2 != 0) begin
            $error("NUM_DIV parameter must be even.");
            $finish;
        end
    end

    // Counter width for NUM_DIV/2 counts
    localparam CNT_WIDTH = $clog2(NUM_DIV/2);

    reg [CNT_WIDTH-1:0] cnt;

    wire terminal_count = (cnt == (NUM_DIV/2 - 1));

    // Counter: counts up to half division factor
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= {CNT_WIDTH{1'b0}};
        else if (terminal_count)
            cnt <= {CNT_WIDTH{1'b0}};
        else
            cnt <= cnt + 1'b1;
    end

    // Toggle clk_div when terminal count reached
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div <= 1'b0;
        else if (terminal_count)
            clk_div <= ~clk_div;
    end

endmodule