module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

// Define the states
reg state_A, state_B;
reg next_state_A, next_state_B;

// Output logic
assign z = (state_A && ~x) || (state_B);

// Next state logic
always @(state_A, state_B, x) begin
    case ({state_A, state_B})
        2'b01: begin // State A
            next_state_A = ~x;
            next_state_B = x;
        end
        2'b10: begin // State B
            next_state_A = 1'b0;
            next_state_B = 1'b1;
        end
        default: begin
            next_state_A = 1'b0;
            next_state_B = 1'b0;
        end
    endcase
end

// State registers
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1;
        state_B <= 1'b0;
    end else begin
        state_A <= next_state_A;
        state_B <= next_state_B;
    end
end

endmodule