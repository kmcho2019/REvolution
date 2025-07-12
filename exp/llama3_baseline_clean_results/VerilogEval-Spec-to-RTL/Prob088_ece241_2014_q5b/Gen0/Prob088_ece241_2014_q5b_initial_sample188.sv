module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

// One-hot encoding for states
reg state_A;
reg state_B;

// Output logic
assign z = (state_A && x) || state_B;

// Next state logic
always @(*) begin
    if (areset) begin
        state_A = 1'b1;
        state_B = 1'b0;
    end else begin
        case ({state_A, state_B})
            2'b10: begin // State A
                if (x) begin
                    state_A = 1'b0;
                    state_B = 1'b1;
                end else begin
                    state_A = 1'b1;
                    state_B = 1'b0;
                end
            end
            2'b01: begin // State B
                state_A = 1'b0;
                state_B = 1'b1;
            end
            default: begin
                state_A = 1'b1;
                state_B = 1'b0;
            end
        endcase
    end
end

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1;
        state_B <= 1'b0;
    end else begin
        reg next_state_A;
        reg next_state_B;
        // Compute next state
        if (state_A && x) begin
            next_state_A = 1'b0;
            next_state_B = 1'b1;
        end else if (state_A && ~x) begin
            next_state_A = 1'b1;
            next_state_B = 1'b0;
        end else if (state_B) begin
            next_state_A = 1'b0;
            next_state_B = 1'b1;
        end else begin
            next_state_A = 1'b1;
            next_state_B = 1'b0;
        end
        // Update state
        state_A <= next_state_A;
        state_B <= next_state_B;
    end
end

endmodule