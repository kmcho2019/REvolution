module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] count; // Counter to track 'w' occurrences in the current window
reg [1:0] clock_cycles; // Counter to track clock cycles
reg state; // State variable to track current state (A or B)

// Sequential logic for counters and state
always @(posedge clk) begin
    if(reset) begin
        state <= 1'b0; // Reset state to A
        count <= 2'b00; // Reset 'w' occurrence counter
        clock_cycles <= 2'b00; // Reset clock cycle counter
    end else begin
        case(state)
            1'b0: // State A
                begin
                    if(s) begin
                        state <= 1'b1; // Transition to state B
                        count <= 2'b00; // Reset 'w' occurrence counter
                        clock_cycles <= 2'b01; // Reset clock cycle counter
                    end else begin
                        state <= 1'b0; // Remain in state A
                        count <= 2'b00; // Reset 'w' occurrence counter
                        clock_cycles <= 2'b00; // Reset clock cycle counter
                    end
                end
            1'b1: // State B
                begin
                    if(w) begin
                        count <= count + 1'b1; // Increment 'w' occurrence counter
                    end
                    if(clock_cycles == 2'b11) begin // Reset counters after 3 clock cycles
                        count <= 2'b00;
                        clock_cycles <= 2'b01;
                    end else begin
                        clock_cycles <= clock_cycles + 1'b1; // Increment clock cycle counter
                    end
                end
            default: ;
        endcase
    end
end

// Combinational logic for output 'z' evaluation
assign z = (clock_cycles == 2'b11 && count == 2'b10) ? 1'b1 : 1'b0;

endmodule