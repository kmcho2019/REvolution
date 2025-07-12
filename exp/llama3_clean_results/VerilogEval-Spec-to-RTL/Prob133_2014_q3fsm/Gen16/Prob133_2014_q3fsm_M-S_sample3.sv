module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg state; // State variable: 0 (A), 1 (B)
reg [2:0] w_shift_reg; // 3-bit shift register to track 'w' occurrences
reg [2:0] w_prev; // Previous value of w_shift_reg

// Sequential logic for state and shift register
always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset state to A
        w_shift_reg <= 3'b000; // Reset shift register
        w_prev <= 3'b000; // Reset previous value of w_shift_reg
        z <= 0; // Reset output z
    end else begin
        case(state)
            0: begin // State A
                if(s) begin
                    state <= 1; // Transition to state B
                    w_shift_reg <= {w, 2'b00}; // Initialize shift register with 'w'
                end
            end
            1: begin // State B
                w_prev <= w_shift_reg; // Store previous value of w_shift_reg
                w_shift_reg <= {w, w_shift_reg[2:1]}; // Shift 'w' into the register
                if(w_prev == 3'b110 || w_prev == 3'b101 || w_prev == 3'b011) begin
                    z <= 1; // Set 'z' high if 'w' occurred exactly twice
                end else begin
                    z <= 0; // Set 'z' low
                end
            end
        endcase
    end
end

endmodule