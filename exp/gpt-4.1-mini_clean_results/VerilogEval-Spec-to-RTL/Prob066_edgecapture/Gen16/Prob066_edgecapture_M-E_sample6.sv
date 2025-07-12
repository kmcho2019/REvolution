module TopModule (
    input          clk,
    input          reset,
    input  [31:0]  in,
    output reg [31:0] out
);

    reg [31:0] armed;

    always @(posedge clk) begin
        if (reset) begin
            armed <= 32'b0;
            out <= 32'b0;
        end else begin
            // Detect falling edges: bits that were armed (previously high)
            // but are now low in 'in'
            out <= out | (armed & ~in);
            // Update armed bits: only bits currently high become armed
            armed <= in;
        end
    end

endmodule