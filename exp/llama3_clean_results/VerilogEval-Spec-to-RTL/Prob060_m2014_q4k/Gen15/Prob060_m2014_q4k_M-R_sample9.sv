// Refactored TopModule with Simplified Shift Register Implementation
module TopModule(
    input clk,
    input resetn,
    input in,
    output reg [3:0] q,
    output reg out
);

always @(posedge clk) begin
    if (!resetn) begin
        q <= 4'b0000;
    end else begin
        q <= {q[2:0], in};
    end
    out <= q[3];
end

endmodule