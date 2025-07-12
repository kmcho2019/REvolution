module TopModule (
    input clk,
    input d,
    output reg q
);

    reg clk_delayed;
    wire edge_detect;

    // Create delayed clock version
    always @(posedge clk or negedge clk) begin
        clk_delayed <= clk;
    end

    // Edge detection (both rising and falling)
    assign edge_detect = clk ^ clk_delayed;

    // Capture data on any edge
    always @(posedge edge_detect) begin
        q <= d;
    end

endmodule