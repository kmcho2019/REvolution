module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    // Register input for edge detection
    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
        end else begin
            prev_in <= in;
        end
    end

    // Detect falling edges and latch them
    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
        end else begin
            // For each bit: set if we detect a falling edge or if it was already set
            out <= out | (prev_in & ~in);
        end
    end

endmodule