module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

// Define states
enum logic [0:0] {OFF, ON} state, next_state;

// Output logic
always_comb begin
    case (state)
        OFF: out = 1'b0;
        ON:  out = 1'b1;
    endcase
end

// Next state logic
always_comb begin
    case (state)
        OFF: begin
            if (j) next_state = ON;
            else   next_state = OFF;
        end
        ON: begin
            if (k) next_state = OFF;
            else   next_state = ON;
        end
    endcase
end

// State register
always_ff @(posedge clk or posedge areset) begin
    if (areset) state <= OFF;
    else        state <= next_state;
end

endmodule