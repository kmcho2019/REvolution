module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;
reg [6:0] rot_cnt; // 2^7 > 100, so 7 bits are sufficient for rotation count

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
        rot_cnt <= 0;
    end else begin
        case (ena)
            2'b01: begin // Rotate right
                rot_cnt <= rot_cnt + 1;
                q_reg <= {q_reg[0], q_reg[99:1]};
            end
            2'b10: begin // Rotate left
                rot_cnt <= rot_cnt - 1;
                q_reg <= {q_reg[98:0], q_reg[99]};
            end
            default: ; // No rotation
        endcase
    end
end

assign q = q_reg;

endmodule