module TopModule (
    input  clk,
    input  reset,
    input  [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_bits;

    always @(posedge clk) begin
        if (reset) begin
            prev_bits <= 32'b0;
            out <= 32'b0;
        end else begin
            // Detect falling edges: prev=1 and in=0
            // Update out by setting bits where falling edge detected, sticky behavior
            out <= out | (prev_bits & ~in);
            // Update prev_bits with current input for next cycle
            prev_bits <= in;
        end
    end

endmodule