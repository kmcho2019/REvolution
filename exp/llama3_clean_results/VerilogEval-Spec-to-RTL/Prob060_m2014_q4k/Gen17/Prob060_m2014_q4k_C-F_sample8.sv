// Parameterizable D Flip-Flop Module with Active-Low Synchronous Reset
module DFF(
    parameter WIDTH = 1,
    input clk,
    input resetn,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

integer i;
always @(posedge clk) begin
    if (!resetn) begin
        for (i = 0; i < WIDTH; i++) begin
            q[i] <= 1'b0;
        end
    end else begin
        q <= d;
    end
end

endmodule

// TopModule with Shift Register
module TopModule(
    input clk,
    input resetn,
    input in,
    output reg out
);

reg [3:0] q;

DFF #(.WIDTH(4)) dff(clk, resetn, {q[2:0], in}, q);

assign out = q[3];

endmodule