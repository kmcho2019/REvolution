module TopModule (
    input clk,
    input d,
    output reg q
);

    reg clk_prev;
    wire sample_edge;

    // Detect both rising and falling edges
    assign sample_edge = (clk ^ clk_prev);

    always @(posedge clk) begin
        clk_prev <= 1'b1;
    end

    always @(negedge clk) begin
        clk_prev <= 1'b0;
    end

    // Update output on both edges
    always @(posedge sample_edge) begin
        q <= d;
    end

endmodule