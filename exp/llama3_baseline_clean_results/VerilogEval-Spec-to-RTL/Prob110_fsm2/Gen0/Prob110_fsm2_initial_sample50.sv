module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

// Define the states
enum logic [0:0] {OFF, ON} state, next_state;

// Output logic: out is 0 in OFF state and 1 in ON state
always @(*) begin
    case (state)
        OFF: out = 0;
        ON:  out = 1;
    endcase
end

// Next state logic
always @(*) begin
    case (state)
        OFF: begin
            if (j) next_state = ON;
            else   next_state = OFF;
        end
        ON:  begin
            if (k) next_state = OFF;
            else   next_state = ON;
        end
    endcase
end

// State register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) state <= OFF;
    else        state <= next_state;
end

endmodule