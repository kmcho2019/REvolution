module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State variable: 2'b00 (A), 2'b01 (B)
reg [2:0] w_shift_reg; // 3-bit shift register to track 'w' occurrences
reg [1:0] w_count; // Counter to track 'w' occurrences in the shift register
reg [1:0] clock_cycle_count; // Counter to track clock cycles since state transition

// Sequential logic for state, shift register, and counter
always @(posedge clk) begin
    if(reset) begin
        state <= 2'b00; // Reset state to A
        w_shift_reg <= 3'b000; // Reset shift register
        w_count <= 2'b00; // Reset counter
        clock_cycle_count <= 2'b00; // Reset clock cycle counter
        z <= 1'b0; // Reset output z
    end else begin
        case(state)
            2'b00: begin // State A
                if(s) begin
                    state <= 2'b01; // Transition to state B
                    w_shift_reg <= {w, 2'b00}; // Initialize shift register with 'w'
                    w_count <= w? 1'b1 : 1'b0; // Initialize counter with 'w'
                    clock_cycle_count <= 2'b01; // Initialize clock cycle counter
                end else begin
                    state <= 2'b00; // Remain in state A
                    w_shift_reg <= 3'b000; // Reset shift register
                    w_count <= 2'b00; // Reset counter
                    clock_cycle_count <= 2'b00; // Reset clock cycle counter
                end
            end
            2'b01: begin // State B
                w_shift_reg <= {w, w_shift_reg[1:0]}; // Shift 'w' into the register
                w_count <= w_count + (w? 1'b1 : 1'b0); // Increment counter if 'w' is 1
                clock_cycle_count <= clock_cycle_count + 1'b1; // Increment clock cycle counter
                if(clock_cycle_count == 2'b11) begin // Evaluate 'z' after 3 clock cycles
                    if(w_count == 2'b10) begin // 'w' occurred exactly twice
                        z <= 1'b1; // Set 'z' high
                    end else begin
                        z <= 1'b0; // Set 'z' low
                    end
                    w_count <= 2'b00; // Reset counter
                    clock_cycle_count <= 2'b00; // Reset clock cycle counter
                end else begin
                    z <= 1'b0; // Set 'z' low
                end
            end
        endcase
    end
end

endmodule