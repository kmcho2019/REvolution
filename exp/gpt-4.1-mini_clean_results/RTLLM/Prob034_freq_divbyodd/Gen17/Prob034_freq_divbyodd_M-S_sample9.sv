module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,     // Active low reset
    output wire clk_div
);

    // Compile-time check for odd NUM_DIV
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam integer CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt;
    reg clk_div_ff;
    reg clk_div_ff_d; // delayed version

    // Counter and toggle flip-flop on positive clock edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt        <= 0;
            clk_div_ff <= 0;
            clk_div_ff_d <= 0;
        end else begin
            if (cnt == NUM_DIV - 1) begin
                cnt <= 0;
                clk_div_ff <= ~clk_div_ff;  // toggle at end of count
            end else begin
                cnt <= cnt + 1;
            end
            clk_div_ff_d <= clk_div_ff; // delayed version for OR
        end
    end

    // Output clock is OR of current and delayed toggled signals to approximate duty cycle
    assign clk_div = clk_div_ff | clk_div_ff_d;

endmodule