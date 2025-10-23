module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;

// Rotation Logic
wire [99:0] rotate_right = {q_reg[0], q_reg[99:1]};
wire [99:0] rotate_left = {q_reg[98:0], q_reg[99]};
wire [99:0] no_rotate = q_reg;

// Output Logic
assign q = q_reg;

// Sequential Logic
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        case (ena)
            2'b01: q_reg <= rotate_right;
            2'b10: q_reg <= rotate_left;
            default: q_reg <= no_rotate;
        endcase
    end
end

endmodule