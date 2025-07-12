module TopModule (
    input clk,
    input d,
    output reg q
);

    reg clk_int = 0;

    // Generate clk_int that toggles on every edge of clk
    // Use both edges of clk to toggle clk_int
    always @(posedge clk or negedge clk) begin
        clk_int <= ~clk_int;
    end

    // Single edge triggered flip-flop on rising edge of clk_int
    always @(posedge clk_int) begin
        q <= d;
    end

endmodule