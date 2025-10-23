module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State variable to track current state (A or B)
reg [2:0] shift_reg; // Shift register to track last three 'w' values

// Sequential logic for state machine and shift register
always @(posedge clk) begin
    if(reset) begin
        state <= 2'b01; // Reset state to A
        shift_reg <= 3'b000; // Reset shift register
        z <= 1'b0; // Reset output 'z'
    end else begin
        case(state)
            2'b01: // State A
                begin
                    if(s) begin
                        state <= 2'b10; // Transition to state B
                        shift_reg <= 3'b000; // Reset shift register
                    end else begin
                        state <= 2'b01; // Remain in state A
                    end
                end
            2'b10: // State B
                begin
                    shift_reg <= {shift_reg[1:0], w}; // Shift in new 'w' value
                    state <= 2'b10; // Remain in state B
                end
            default: ;
        endcase
    end
end

// Combinational logic for output 'z' evaluation
always @(*) begin
    if(state == 2'b10) begin // Only evaluate in state B
        if(shift_reg == 3'b110 || shift_reg == 3'b101 || shift_reg == 3'b011) begin // Check if exactly two '1's in shift register
            z = 1'b1;
        end else begin
            z = 1'b0;
        end
    end else begin
        z = 1'b0; // In state A, 'z' is 0
    end
end

endmodule