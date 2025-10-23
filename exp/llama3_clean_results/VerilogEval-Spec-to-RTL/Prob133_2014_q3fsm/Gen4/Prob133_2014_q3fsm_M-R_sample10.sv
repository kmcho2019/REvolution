module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

// Define states
enum {A, B} state, next_state;

// Counters
reg [1:0] cycle_counter;
reg [1:0] w_counter;

// Next state and output logic
always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= A;
        cycle_counter <= 2'b00;
        w_counter <= 2'b00;
        z <= 1'b0;
    end else begin
        case(state)
            A: begin
                if(s) begin
                    state <= B;
                    cycle_counter <= 2'b01;
                    w_counter <= 2'b00;
                end else begin
                    state <= A;
                end
            end
            B: begin
                if(cycle_counter == 2'b11) begin // End of three clock cycles
                    if(w_counter == 2'b10) begin // Exactly two w = 1 occurrences
                        z <= 1'b1;
                    end else begin
                        z <= 1'b0;
                    end
                    state <= B; // Stay in state B
                    cycle_counter <= 2'b01; // Reset cycle counter
                    w_counter <= 2'b00; // Reset w counter
                end else begin
                    if(w) begin
                        w_counter <= w_counter + 1; // Increment w counter if w = 1
                    end
                    cycle_counter <= cycle_counter + 1; // Increment cycle counter
                    state <= B; // Stay in state B
                end
            end
        endcase
    end
end

endmodule