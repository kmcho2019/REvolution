module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 8'b0;  // Reset all bits to 0 simultaneously
        end
        else begin
            q <= d;      // Update all bits with input data
        end
    end

endmodule