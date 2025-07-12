module TopModule (
    input clk,
    input d,
    output reg q
);
    reg clk_dly;
    reg toggle;

    // Delay clock by one cycle for edge detection
    always @(posedge clk) begin
        clk_dly <= clk;
    end

    // Toggle on every clock edge (rising or falling)
    always @(posedge clk) begin
        toggle <= ~toggle;
    end

    // Generate an enable pulse on both edges by detecting clk != clk_dly
    wire enable = (clk ^ clk_dly);

    // Capture data on positive edge only when enable is asserted (i.e., on both edges of clk)
    always @(posedge clk) begin
        if (enable)
            q <= d;
    end

endmodule