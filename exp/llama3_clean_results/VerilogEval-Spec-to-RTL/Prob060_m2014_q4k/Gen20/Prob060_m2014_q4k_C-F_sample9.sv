// Parameterized D Flip-Flop Module with Active-Low Synchronous Reset
module ParamDFF(
    parameter WIDTH = 4,
    input clk,
    input resetn,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

always @(posedge clk) begin
    if (!resetn) begin
        q <= {WIDTH{1'b0}};
    end else begin
        q <= d;
    end
end

endmodule

// TopModule with Parameterized D Flip-Flop Shift Register
module TopModule(
    input clk,
    input resetn,
    input in,
    output reg out
);

reg [3:0] q;

// Instantiate the parameterized D flip-flop module
ParamDFF #(.WIDTH(4)) param_dff(clk, resetn, {q[2:0], in}, q);

// Assign output directly from the last bit of the D flip-flop
assign out = q[3];

endmodule