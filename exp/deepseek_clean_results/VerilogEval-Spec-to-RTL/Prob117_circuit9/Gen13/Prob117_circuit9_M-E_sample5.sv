module TopModule (
    input clk,
    input a,
    output reg [2:0] q = 3'b100  // Initialize to 4
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'b100;  // Reset to 4 when a is high
    end else begin
        q <= {q[1:0], q[2]};  // Rotate left
    end
end

endmodule