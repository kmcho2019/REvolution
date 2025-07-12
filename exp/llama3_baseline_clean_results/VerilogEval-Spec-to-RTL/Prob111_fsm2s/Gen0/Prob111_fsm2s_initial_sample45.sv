module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Enumerate states
enum logic [0:0] {OFF, ON} state, next_state;

// Output logic based on current state
always_comb begin
    case (state)
        OFF: out = 1'b0;
        ON:  out = 1'b1;
    endcase
end

// State machine
always_ff @(posedge clk) begin
    if (reset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    case (state)
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
    endcase
end

endmodule