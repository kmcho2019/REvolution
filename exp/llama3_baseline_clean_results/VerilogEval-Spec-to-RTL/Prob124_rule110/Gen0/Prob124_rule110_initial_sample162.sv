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
            reg left, center, right, next_state;
            if (i == 0) begin
                left = 0;
                center = q_reg[i];
                if (i == 511) begin
                    right = 0;
                end else begin
                    right = q_reg[i + 1];
                end
            end else if (i == 511) begin
                left = q_reg[i - 1];
                center = q_reg[i];
                right = 0;
            end else begin
                left = q_reg[i - 1];
                center = q_reg[i];
                right = q_reg[i + 1];
            end
            
            case ({left, center, right})
                3'b111: next_state = 0;
                3'b110: next_state = 1;
                3'b101: next_state = 1;
                3'b100: next_state = 0;
                3'b011: next_state = 1;
                3'b010: next_state = 1;
                3'b001: next_state = 1;
                3'b000: next_state = 0;
                default: next_state = 0;
            endcase
            q_reg[i] <= next_state;
        end
    end
end

assign q = q_reg;

endmodule