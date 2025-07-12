module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

// Define the states
enum {OFF, ON} state, next_state;

// Output logic
always_comb begin
    case(state)
        OFF: out = 1'b0;
        ON: out = 1'b1;
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
    endcase
end

// Synchronous reset
always_ff @(posedge clk) begin
    if(reset) state <= OFF;
    else state <= next_state;
end

endmodule