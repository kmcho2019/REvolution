module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 8'b0;
    end
    else begin
        // Conditional rotate based on LSB of input
        if (d[0]) begin
            q <= {q[6:0], q[7]};  // Rotate right
        end
        else begin
            q <= d;  // Normal load
        end
    end
end

endmodule