module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            out <= 32'b0;
        end
        else begin
            prev_in <= in;
            // Detect falling edges (1->0 transitions between prev_in and in)
            // and maintain the output until reset
            out <= out | (prev_in & ~in);
        end
    end

endmodule