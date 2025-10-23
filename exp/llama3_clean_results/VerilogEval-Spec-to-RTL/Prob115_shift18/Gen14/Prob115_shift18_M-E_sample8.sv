module TopModule(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output [63:0] q
);

reg [63:0] q_reg;
reg [63:0] q_next;
reg [7:0] shift_amount;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else if (ena) begin
        case (amount)
            2'b00: begin
                q_next <= {q_reg[62:0], 1'b0};
            end
            2'b01: begin
                q_next <= {q_reg[55:0], 8'd0};
            end
            2'b10: begin
                q_next <= {q_reg[63], q_reg[63:1]};
            end
            2'b11: begin
                q_next <= {{8{q_reg[63]}}, q_reg[63:8]};
            end
            default: begin
                q_next <= q_reg;
            end
        endcase
        q_reg <= q_next;
    end else begin
        q_reg <= q_reg;
    end
end

assign q = q_reg;

endmodule