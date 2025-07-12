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
            wire [2:0] state;
            if (i == 0) state[2] = 0; else state[2] = q_reg[i - 1];
            state[1] = q_reg[i];
            if (i == 511) state[0] = 0; else state[0] = q_reg[i + 1];

            case (state)
                3'b111: q_reg[i] <= 0;
                3'b110, 3'b101, 3'b011, 3'b010, 3'b001: q_reg[i] <= 1;
                default: q_reg[i] <= 0;
            endcase
        end
    end
end

assign q = q_reg;

endmodule