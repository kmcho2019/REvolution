module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

// Define states
enum logic [0:0] {OFF, ON} state, next_state;

// Output logic
always @* begin
    case(state)
        OFF: out = 0;
        ON: out = 1;
    endcase
end

// State transition logic
always_comb begin
    case(state)
        OFF: begin
            if(j) next_state = ON;
            else next_state = OFF;
        end
        ON: begin
            if(k) next_state = OFF;
            else next_state = ON;
        end
        default: next_state = OFF;
    endcase
end

// State register with asynchronous reset
always_ff @(posedge clk or posedge areset) begin
    if(areset) state <= OFF;
    else state <= next_state;
end

endmodule