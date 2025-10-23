module TopModule (
    input  clk,
    input  reset,
    input  [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev;

    always @(posedge clk) begin
        if (reset) begin
            prev <= 32'b0;
            out <= 32'b0;
        end else begin
            // Detect falling edges: bit was 1 and now is 0
            out <= out | (prev & ~in);
            prev <= in;
        end
    end

endmodule