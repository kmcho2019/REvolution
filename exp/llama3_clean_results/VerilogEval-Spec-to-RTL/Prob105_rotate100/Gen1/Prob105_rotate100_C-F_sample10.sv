module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else if (ena != 2'b00 && ena != 2'b11) begin // clock gating
        case (ena)
            2'b01: begin
                q_reg <= {q_reg[0], q_reg[99:1]};
            end
            2'b10: begin
                q_reg <= {q_reg[98:0], q_reg[99]};
            end
        endcase
    end
end

assign q = q_reg;

endmodule