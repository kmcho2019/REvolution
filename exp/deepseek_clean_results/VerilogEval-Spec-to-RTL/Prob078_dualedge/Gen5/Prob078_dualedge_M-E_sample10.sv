module TopModule (
    input clk,
    input d,
    output reg q
);

    reg clk_prev;
    wire sample_pulse;

    // Detect clock edges
    always @(posedge clk) begin
        clk_prev <= 1'b1;
    end

    always @(negedge clk) begin
        clk_prev <= 1'b0;
    end

    // Generate sample pulse on both edges
    assign sample_pulse = (clk ^ clk_prev);

    // Sample data on both edges
    always @(posedge sample_pulse) begin
        q <= d;
    end

endmodule