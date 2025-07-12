module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [2:0] shift_reg; // Shift register to store 'w' history
reg state; // State variable: 0 for state A, 1 for state B
reg z_reg; // Register for output z

always @(posedge clk) begin
    if(reset) begin
        // Reset logic
        state <= 0;
        shift_reg <= 0;
        z_reg <= 0;
    end
    else begin
        case(state)
            0: begin
                // State A
                if(s) begin
                    // Transition to state B
                    state <= 1;
                end
            end
            1: begin
                // State B
                // Shift 'w' into the shift register
                shift_reg <= {shift_reg[1:0], w};
                // Check if we have a full history (3 cycles)
                if(shift_reg[2] != 0 || shift_reg[1] != 0 || shift_reg[0] != 0) begin
                    // Check the contents of the shift register
                    if((shift_reg[2] + shift_reg[1] + shift_reg[0]) == 2) begin
                        // Set 'z' to 1 if exactly two bits are 1
                        z_reg <= 1;
                    end
                    else begin
                        // Otherwise, set 'z' to 0
                        z_reg <= 0;
                    end
                end
            end
        endcase
    end
end

assign z = z_reg;

endmodule