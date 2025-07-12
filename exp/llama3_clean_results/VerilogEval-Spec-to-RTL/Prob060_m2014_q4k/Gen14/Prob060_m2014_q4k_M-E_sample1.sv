// TopModule with MUX-Based Shift Register
module TopModule(
    input clk,
    input resetn,
    input in,
    output reg out
);

reg [3:0] q;

always @(posedge clk) begin
    if (!resetn) begin
        q <= 4'b0;
    end else begin
        q <= {in, q[3:1]};
    end
end

assign out = q[0];

endmodule