module TopModule(
    input       clk,
    input       reset,
    input       j,
    input       k,
    output      out
);

// Enum for states
enum logic [0:0] {OFF, ON} current_state, next_state;

// Sequential logic for state update
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic for next state calculation
always_comb begin
    case (current_state)
        OFF: begin
            if (j) begin
                next_state = ON;
            end else begin
                next_state = OFF;
            end
        end
        ON: begin
            if (k) begin
                next_state = OFF;
            end else begin
                next_state = ON;
            end
        end
        default: next_state = OFF; // This should never happen
    endcase
end

// Output logic
always_comb begin
    case (current_state)
        OFF: out = 1'b0;
        ON:  out = 1'b1;
        default: out = 1'b0; // This should never happen
    endcase
end

endmodule