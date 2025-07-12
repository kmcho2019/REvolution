module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] in_d1, in_d2;

    always @(posedge clk) begin
        if (reset) begin
            in_d1 <= 32'b0;
            in_d2 <= 32'b0;
            out <= 32'b0;
        end else begin
            in_d2 <= in_d1;
            in_d1 <= in;
            // Detect falling edges: bit was 1 in in_d2 and 0 in in_d1
            out <= out | (in_d2 & ~in_d1);
        end
    end

endmodule