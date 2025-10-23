module TopModule(
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

assign q = q_reg;

always @ (posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        for (int i = 0; i < 512; i++) begin
            reg left, center, right;
            if (i == 0) begin
                left = 1'b0;
            end else begin
                left = q_reg[i-1];
            end
            center = q_reg[i];
            if (i == 511) begin
                right = 1'b0;
            end else begin
                right = q_reg[i+1];
            end
            case ({left, center, right})
                3'b111, 3'b000, 3'b001, 3'b010: q_reg[i] <= 1'b0;
                3'b110, 3'b101, 3'b100, 3'b011: q_reg[i] <= 1'b1;
                default: q_reg[i] <= 1'b0; // This should never happen
            endcase
        end
    end
end

endmodule