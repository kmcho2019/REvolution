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
                if(shift_reg == 3'b101 || shift_reg == 3'b110 || shift_reg == 3'b011) begin
                    z <= 1'b1; // Set z if w occurred exactly twice
                end else begin
                    z <= 1'b0;
                end
            end
        endcase
    end
end

endmodule