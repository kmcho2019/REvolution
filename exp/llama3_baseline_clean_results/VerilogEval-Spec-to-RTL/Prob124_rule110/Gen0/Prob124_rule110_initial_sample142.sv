module TopModule(
    input           clk,
    input           load,
    input  [511:0]  data,
    output [511:0]  q
);

reg [511:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        for (int i = 0; i < 512; i++) begin
            case ({q_reg[(i+1)%512], q_reg[i], (i > 0) ? q_reg[i-1] : 1'b0})
                3'b111: q_reg[i] <= 1'b0;
                3'b110: q_reg[i] <= 1'b1;
                3'b101: q_reg[i] <= 1'b1;
                3'b100: q_reg[i] <= 1'b0;
                3'b011: q_reg[i] <= 1'b1;
                3'b010: q_reg[i] <= 1'b1;
                3'b001: q_reg[i] <= 1'b1;
                3'b000: q_reg[i] <= 1'b0;
                default: q_reg[i] <= q_reg[i];
            endcase
        end
    end
end

assign q = q_reg;

endmodule