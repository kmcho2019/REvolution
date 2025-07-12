module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
        end else begin
            out <= out | (~in & {32{1'b1}}); // Use bit-wise operations to set flag bits
        end
    end

endmodule