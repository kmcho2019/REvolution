module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [2:0] shift_reg; // Shift register to track w occurrences
reg state; // State A = 0, State B = 1

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 1'b0; // Reset to state A
        shift_reg <= 3'b000; // Reset shift register
        z <= 1'b0;
    end else begin
        case(state)
            1'b0: begin // State A
                if(s) begin
                    state <= 1'b1; // Transition to state B
                end
            end
            1'b1: begin // State B
                shift_reg <= {w, shift_reg[2:1]}; // Shift w into register
                // Count '1's in shift_reg and set z if count equals 2
                z <= (shift_reg[0] + shift_reg[1] + shift_reg[2]) == 2 ? 1'b1 : 1'b0;
            end
        endcase
    end
end

endmodule