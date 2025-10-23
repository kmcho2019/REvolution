module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;

always @(posedge clk) begin
    case ({load, ena})
        3'b100: q_reg <= data; // load
        3'b001: q_reg <= {q_reg[0], q_reg[99:1]}; // rotate right
        3'b010: q_reg <= {q_reg[98:0], q_reg[99]}; // rotate left
        default: q_reg <= q_reg; // no operation
    endcase
end

assign q = q_reg;

endmodule