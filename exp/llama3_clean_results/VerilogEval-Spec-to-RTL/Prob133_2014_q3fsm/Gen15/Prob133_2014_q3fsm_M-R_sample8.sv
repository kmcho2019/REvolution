module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

enum {A, B} state; // Enum for states A and B
reg [2:0] w_reg; // 3-bit register to track 'w' occurrences
reg [1:0] w_count; // Counter to track 'w' occurrences in the register
reg [1:0] clock_cycle_count; // Counter to track clock cycles since state transition

// Sequential logic for state, register, and counter
always @(posedge clk) begin
    if(reset) begin
        state <= A; // Reset state to A
        w_reg <= 3'b000; // Reset register
        w_count <= 2'b00; // Reset counter
        clock_cycle_count <= 2'b00; // Reset clock cycle counter
        z <= 1'b0; // Reset output z
    end else begin
        case(state)
            A: begin
                if(s) begin
                    state <= B; // Transition to state B
                    w_reg <= {w, 2'b00}; // Initialize register with 'w'
                    w_count <= w? 1'b1 : 1'b0; // Initialize counter with 'w'
                    clock_cycle_count <= 2'b01; // Initialize clock cycle counter
                end
            end
            B: begin
                w_reg <= {w, w_reg[1:0]}; // Shift 'w' into the register
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
                end
            end
        endcase
    end
end

endmodule