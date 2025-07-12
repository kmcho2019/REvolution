// Improved TopModule with Shift Register
module TopModule(
    input clk,
    input resetn,
    input in,
    output reg out
);

reg [3:0] q;

always @(posedge clk) begin
    if (!resetn) begin
        q <= 4'b0000;
    end else begin
        // Using a simple shift operation directly
        q <= {in, q[3:1]};
    end
end

assign out = q[3];

endmodule