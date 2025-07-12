module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;
reg [99:0] q_next;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        case (ena)
            2'b01: q_reg <= {q_reg[0], q_reg[99:1]};
            2'b10: q_reg <= {q_reg[98:0], q_reg[99]};
            default: q_reg <= q_reg;
        endcase
    end
end

always @(*) begin
    case (ena)
        2'b01: q_next = {q_reg[0], q_reg[99:1]};
        2'b10: q_next = {q_reg[98:0], q_reg[99]};
        default: q_next = load? data : q_reg;
    endcase
end

assign q = load? data : (ena == 2'b01)? {q_reg[0], q_reg[99:1]} : (ena == 2'b10)? {q_reg[98:0], q_reg[99]} : q_reg;

endmodule