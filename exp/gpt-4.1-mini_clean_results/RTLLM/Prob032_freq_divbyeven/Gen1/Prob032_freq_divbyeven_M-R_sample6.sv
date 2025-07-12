module freq_diveven #(
    parameter NUM_DIV = 4  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    reg [3:0] cnt;
    wire terminal_count;

    // Compile-time check for even NUM_DIV
    initial begin
        if (NUM_DIV % 2 != 0) begin
            $error("NUM_DIV must be an even number");
            $finish;
        end
    end

    // Terminal count signal goes high when counter reaches (NUM_DIV/2 - 1)
    assign terminal_count = (cnt == (NUM_DIV/2 - 1));

    // Counter increments on clk, resets at terminal count or reset asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 4'd0;
        else if (terminal_count)
            cnt <= 4'd0;
        else
            cnt <= cnt + 1'b1;
    end

    // Toggle clk_div only on terminal count
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div <= 1'b0;
        else if (terminal_count)
            clk_div <= ~clk_div;
    end

endmodule