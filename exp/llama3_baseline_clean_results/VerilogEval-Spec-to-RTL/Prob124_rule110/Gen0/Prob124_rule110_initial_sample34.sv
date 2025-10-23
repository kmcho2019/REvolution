module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        for (int i = 0; i < 512; i++) begin
            if (i == 0) begin
                q_reg[i] <= rule110(q_reg[i], q_reg[i + 1], 1'b0);
            end else if (i == 511) begin
                q_reg[i] <= rule110(q_reg[i - 1], q_reg[i], 1'b0);
            end else begin
                q_reg[i] <= rule110(q_reg[i - 1], q_reg[i], q_reg[i + 1]);
            end
        end
    end
end

assign q = q_reg;

function logic rule110(logic left, logic center, logic right);
    case ({left, center, right})
        3'b111: rule110 = 1'b0;
        3'b110: rule110 = 1'b1;
        3'b101: rule110 = 1'b1;
        3'b100: rule110 = 1'b0;
        3'b011: rule110 = 1'b1;
        3'b010: rule110 = 1'b1;
        3'b001: rule110 = 1'b1;
        3'b000: rule110 = 1'b0;
        default: rule110 = 1'bx;
    endcase
endfunction

endmodule