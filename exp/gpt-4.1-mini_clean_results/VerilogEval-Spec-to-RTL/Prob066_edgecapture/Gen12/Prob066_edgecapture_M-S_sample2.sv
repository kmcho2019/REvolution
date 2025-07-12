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
        end else begin
            // Detect falling edges where previous bit was 1 and current bit is 0
            out <= out | (prev_in & ~in);
            prev_in <= in;
        end
    end

endmodule