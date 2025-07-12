module TopModule (
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
            // Handle edge cases
            left  = (i == 0)? 1'b0 : q_reg[i-1];
            center = q_reg[i];
            right = (i == 511)? 1'b0 : q_reg[i+1];
            
            // Apply Rule 90
            case ({left, center, right})
                3'b111: next_state = 1'b0;
                3'b110: next_state = 1'b1;
                3'b101: next_state = 1'b0;
                3'b100: next_state = 1'b1;
                3'b011: next_state = 1'b1;
                3'b010: next_state = 1'b0;
                3'b001: next_state = 1'b1;
                3'b000: next_state = 1'b0;
                default: next_state = 1'b0; // This line should never be reached
            endcase
            
            q_reg[i] <= next_state;
        end
    end
end

assign q = q_reg;

endmodule