module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;
    reg [31:0] capture;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            capture <= 32'b0;
        end
        else begin
            // Detect falling edges (1->0 transitions) for all bits in parallel
            capture <= capture | (prev_in & ~in);
            // Store current input for next cycle
            prev_in <= in;
        end
    end

    assign out = capture;

endmodule