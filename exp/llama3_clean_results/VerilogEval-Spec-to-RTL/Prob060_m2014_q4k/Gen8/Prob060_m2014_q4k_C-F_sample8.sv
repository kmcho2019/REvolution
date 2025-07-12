// Parameterized D Flip-Flop Module with Active-Low Synchronous Reset
module DFF(
    parameter WIDTH = 1,
    input clk,
    input resetn,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);

reg [WIDTH-1:0] q_reg;
assign q = q_reg;

always @(posedge clk) begin
    if (!resetn) begin
        q_reg <= {WIDTH{1'b0}};
    end else begin
        q_reg <= d;
    end
end

endmodule

// TopModule with Shift Register
module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

parameter SHIFT_REG_WIDTH = 4;

reg [SHIFT_REG_WIDTH-1:0] shift_reg;

always @(posedge clk) begin
    if (!resetn) begin
        shift_reg <= {SHIFT_REG_WIDTH{1'b0}};
    end else begin
        shift_reg <= {shift_reg[SHIFT_REG_WIDTH-2:0], in};
    end
end

assign out = shift_reg[SHIFT_REG_WIDTH-1];

endmodule