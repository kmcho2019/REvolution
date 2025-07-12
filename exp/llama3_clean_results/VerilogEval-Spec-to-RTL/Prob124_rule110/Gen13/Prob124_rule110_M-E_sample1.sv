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
        reg [511:0] next_state;
        integer i;
        for (i = 0; i < 512; i++) begin
            reg left, center, right;
            
            // Handle boundary conditions
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
            
            // Apply Rule 110 logic using LUT
            case ({left, center, right})
                3'b111: next_state[i] = 1'b0;
                3'b110: next_state[i] = 1'b1;
                3'b101: next_state[i] = 1'b1;
                3'b100: next_state[i] = 1'b0;
                3'b011: next_state[i] = 1'b1;
                3'b010: next_state[i] = 1'b1;
                3'b001: next_state[i] = 1'b1;
                3'b000: next_state[i] = 1'b0;
                default: next_state[i] = 1'b0;
            endcase
        end
        q_reg <= next_state;
    end
    q <= q_reg;
end

endmodule