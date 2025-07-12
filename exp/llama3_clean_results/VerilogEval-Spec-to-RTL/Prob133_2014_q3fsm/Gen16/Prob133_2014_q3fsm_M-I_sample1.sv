module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State variable to track current state (A or B)
reg [1:0] count; // Counter to track 'w' occurrences in the current window
reg [1:0] clock_cycles; // Counter to track clock cycles

// Sequential logic for state, counters, and output z
always @(posedge clk) begin
    if(reset) begin
        state <= 2'b00; // Reset state to A
        count <= 2'b00; // Reset 'w' occurrence counter
        clock_cycles <= 2'b00; // Reset clock cycle counter
        z <= 1'b0; // Reset output z
    end else begin
        case(state)
            2'b00: // State A
                begin
                    if(s) begin
                        state <= 2'b01; // Transition to state B
                        count <= 2'b00; // Reset 'w' occurrence counter
                        clock_cycles <= 2'b00; // Reset clock cycle counter
                    end else begin
                        state <= 2'b00; // Remain in state A
                    end
                end
            2'b01: // State B
                begin
                    if(w) begin
                        count <= count + 1'b1; // Increment 'w' occurrence counter
                    end
                    clock_cycles <= clock_cycles + 1'b1; // Increment clock cycle counter
                    if(clock_cycles == 2'b10) begin // Evaluate output 'z' after 3 clock cycles
                        if(count == 2'b10) begin
                            z <= 1'b1; // Set 'z' high if 'w' occurred exactly twice in the previous window
                        end else begin
                            z <= 1'b0;
                        end
                        count <= 2'b00; // Reset 'w' occurrence counter
                        clock_cycles <= 2'b00; // Reset clock cycle counter
                    end
                end
            default: ;
        endcase
    end
end

endmodule