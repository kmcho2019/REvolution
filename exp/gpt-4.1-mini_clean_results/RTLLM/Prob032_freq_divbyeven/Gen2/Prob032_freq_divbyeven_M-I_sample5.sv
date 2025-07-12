module freq_diveven #(
    parameter NUM_DIV = 4  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Calculate the width of counter based on NUM_DIV parameter
    localparam CNT_WIDTH = $clog2(NUM_DIV/2);

    reg [CNT_WIDTH-1:0] cnt;

    // Compile-time check for even NUM_DIV
    initial begin
        if (NUM_DIV % 2 != 0) begin
            $error("NUM_DIV must be an even number");
            $finish;
        end
    end

    wire terminal_count = (cnt == (NUM_DIV/2 - 1));

    // Single always block for synchronous reset, counter and clk_div toggle
    always @(posedge clk) begin
        if (!rst_n) begin
            cnt <= {CNT_WIDTH{1'b0}};
            clk_div <= 1'b0;
        end else if (terminal_count) begin
            cnt <= {CNT_WIDTH{1'b0}};
            clk_div <= ~clk_div;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end

endmodule