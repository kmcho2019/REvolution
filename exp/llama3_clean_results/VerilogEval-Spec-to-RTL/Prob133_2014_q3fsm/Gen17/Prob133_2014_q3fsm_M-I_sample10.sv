module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [2:0] shift_reg; // Shift register to track 'w' over 3 clock cycles
reg state; // State variable to track current state (A or B)

// Sequential and combinational logic
always @(posedge clk) begin
    if(reset) begin
        state <= 1'b0; // Reset state to A
        shift_reg <= 3'b000; // Reset shift register
        z <= 1'b0; // Reset output 'z'
    end else begin
        case(state)
            1'b0: // State A
                begin
                    if(s) begin
                        state <= 1'b1; // Transition to state B
                    end else begin
                        state <= 1'b0; // Remain in state A
                    end
                    shift_reg <= 3'b000; // Reset shift register
                end
            1'b1: // State B
                begin
                    // Shift 'w' into the shift register
                    shift_reg <= {w, shift_reg[2:1]};
                    state <= 1'b1; // Remain in state B
                end
            default: ;
        endcase

        // Combinational logic for output 'z' evaluation
        if(state == 1'b1) begin // Only evaluate in state B
            // Count the number of '1's in the shift register
            if((shift_reg[0] == 1'b1 && shift_reg[1] == 1'b1 && shift_reg[2] == 1'b0) ||
               (shift_reg[0] == 1'b1 && shift_reg[1] == 1'b0 && shift_reg[2] == 1'b1) ||
               (shift_reg[0] == 1'b0 && shift_reg[1] == 1'b1 && shift_reg[2] == 1'b1)) begin
                z <= 1'b1;
            end else begin
                z <= 1'b0;
            end
        end else begin
            z <= 1'b0; // In state A, 'z' is always 0
        end
    end
end

endmodule