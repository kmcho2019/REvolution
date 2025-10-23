module TopModule(
    input clk,
    input reset,
    input w,
    output logic z
);

// One-hot encoding for states to potentially reduce power consumption
logic [5:0] state, next_state;

always_ff @(posedge clk) begin
    if(reset) begin
        state <= 6'b000001; // Initialize to state A
    end else begin
        state <= next_state;
    end
end

always_comb begin
    next_state = '0; // Reset next_state to avoid latches
    casez(state)
        6'b000001: begin // State A
            if(~w) begin
                next_state = 6'b000010; // Transition to B
            end else begin
                next_state = 6'b000001; // Stay in A
            end
            z = 0;
        end
        6'b000010: begin // State B
            if(~w) begin
                next_state = 6'b000100; // Transition to C
            end else begin
                next_state = 6'b000040; // Transition to D
            end
            z = 0;
        end
        6'b000100: begin // State C
            if(~w) begin
                next_state = 6'b001000; // Transition to E
            end else begin
                next_state = 6'b000040; // Transition to D
            end
            z = 0;
        end
        6'b001000: begin // State E
            if(~w) begin
                next_state = 6'b001000; // Stay in E
            end else begin
                next_state = 6'b000040; // Transition to D
            end
            z = 1;
        end
        6'b000040: begin // State D
            if(~w) begin
                next_state = 6'b010000; // Transition to F
            end else begin
                next_state = 6'b000001; // Transition to A
            end
            z = 0;
        end
        6'b010000: begin // State F
            if(~w) begin
                next_state = 6'b000100; // Transition to C
            end else begin
                next_state = 6'b000040; // Transition to D
            end
            z = 1;
        end
        default: begin
            next_state = 6'b000001; // Default to A
            z = 0;
        end
    endcase
end

endmodule