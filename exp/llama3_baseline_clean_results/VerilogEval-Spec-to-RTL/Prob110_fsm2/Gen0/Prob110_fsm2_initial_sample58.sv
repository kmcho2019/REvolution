module TopModule (
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

// Define states as enumerations
enum logic [0:0] {OFF, ON} current_state, next_state;

// Output logic
assign out = (current_state == ON) ? 1'b1 : 1'b0;

// State machine logic
always_comb begin
    case (current_state)
        OFF: begin
            if (j) next_state = ON;
            else next_state = OFF;
        end
        ON: begin
            if (k) next_state = OFF;
            else next_state = ON;
        end
        default: next_state = OFF;
    endcase
end

// State register
always_ff @(posedge clk or posedge areset) begin
    if (areset) current_state <= OFF;
    else current_state <= next_state;
end

endmodule