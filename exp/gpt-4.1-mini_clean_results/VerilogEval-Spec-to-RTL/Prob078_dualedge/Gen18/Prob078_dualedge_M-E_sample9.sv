module TopModule (
    input clk,
    input d,
    output reg q
);

    // Generate double frequency clock (clk_2x) by XORing clk and its delayed version
    // To avoid combinational loops, use a toggle flip-flop clocked on posedge clk and negedge clk
    reg clk_toggle;

    always @(posedge clk or negedge clk) begin
        clk_toggle <= ~clk_toggle;
    end

    // Use clk_toggle as the double frequency clock for sampling d
    always @(posedge clk_toggle) begin
        q <= d;
    end

endmodule