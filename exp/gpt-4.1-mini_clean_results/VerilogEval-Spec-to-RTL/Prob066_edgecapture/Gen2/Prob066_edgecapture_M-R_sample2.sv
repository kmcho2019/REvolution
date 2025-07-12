module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    // Sequential logic to update prev_in and out
    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            out <= 32'b0;
        end else begin
            // Detect bits that changed from 1 to 0 by comparing prev_in to current in
            // Update output to latch the detected bits
            out <= out | (prev_in & ~in);
            // Update prev_in for next cycle comparison
            prev_in <= in;
        end
    end

endmodule