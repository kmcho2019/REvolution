// D Flip-Flop Module with Active-Low Synchronous Reset
module DFF(
    input clk,
    input resetn,
    input d,
    output reg q
);

always @(posedge clk) begin
    if (!resetn) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule

// Generic Shift Register Module
module ShiftRegister(
    parameter WIDTH = 4, // Default width is 4
    input clk,
    input resetn,
    input in,
    output [WIDTH-1:0] out
);

reg [WIDTH-1:0] q;

always @(posedge clk) begin
    if (!resetn) begin
        q <= {WIDTH{1'b0}};
    end else begin
        q <= {in, q[WIDTH-1:1]};
    end
end

assign out = q;

endmodule

// TopModule with Shift Register
module TopModule(
    input clk,
    input resetn,
    input in,
    output reg out
);

wire [3:0] shift_out;

ShiftRegister #(.WIDTH(4)) shift_reg(clk, resetn, in, shift_out);

assign out = shift_out[3];

endmodule