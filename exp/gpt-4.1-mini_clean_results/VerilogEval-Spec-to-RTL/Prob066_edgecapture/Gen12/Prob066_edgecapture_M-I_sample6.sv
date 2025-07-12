module TopModule (
    input wire clk,
    input wire reset,
    input wire [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= in;       // Initialize prev_in to actual input value at reset
            out <= 32'b0;        // Clear output on reset
        end else begin
            // Detect falling edges: bit was 1 in prev_in and is 0 in current in
            // Update out to hold any detected falling edges until next reset
            out <= out | (prev_in & ~in);
            prev_in <= in;       // Update prev_in to current input for next cycle
        end
    end

endmodule