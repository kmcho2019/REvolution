module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] in_prev;
    wire [31:0] transitions;

    // Combinational logic to detect 1->0 transitions
    assign transitions = in_prev & ~in;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            in_prev <= 32'b0;
        end
        else begin
            // Accumulate all detected transitions
            out <= out | transitions;
            in_prev <= in;
        end
    end

endmodule