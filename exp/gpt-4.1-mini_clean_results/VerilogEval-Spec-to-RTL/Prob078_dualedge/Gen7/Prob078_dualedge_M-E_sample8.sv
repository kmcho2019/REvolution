module TopModule (
    input clk,
    input d,
    output reg q
);
    // Generate enable signal that pulses at both edges of clk
    reg clk_delayed;
    reg enable;

    // Capture clk delayed by one clk cycle
    always @(posedge clk) begin
        clk_delayed <= clk;
    end

    // Enable is high for one clk cycle if clk changes (either edge)
    always @(posedge clk) begin
        enable <= clk ^ clk_delayed;
    end

    // Sample input d on rising clk edge when enable is high
    always @(posedge clk) begin
        if (enable)
            q <= d;
    end

endmodule