module TopModule(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output [63:0] q
);

reg [63:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else if (ena) begin
        case (amount)
            2'b00: q_reg <= {q_reg[62:0], 1'b0};  // shift left by 1 bit
            2'b01: q_reg <= {q_reg[55:0], 8'b0};  // shift left by 8 bits
            2'b10: begin  // shift right by 1 bit
                if (q_reg[63]) begin
                    q_reg <= {q_reg[63], q_reg[63:1]};
                end else begin
                    q_reg <= {1'b0, q_reg[63:1]};
                end
            end
            2'b11: begin  // shift right by 8 bits
                if (q_reg[63]) begin
                    q_reg <= {8{q_reg[63]}, q_reg[63:8]};
                end else begin
                    q_reg <= {8'b0, q_reg[63:8]};
                end
            end
        endcase
    end
end

assign q = q_reg;

endmodule