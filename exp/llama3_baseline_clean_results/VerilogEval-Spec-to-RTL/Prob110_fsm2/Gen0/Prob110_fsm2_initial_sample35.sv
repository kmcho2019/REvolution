module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

// Define the states of the FSM
enum logic [0:0] {OFF, ON} current_state, next_state;

// Output is determined by the current state (Moore Machine)
assign out = (current_state == ON) ? 1'b1 : 1'b0;

// Determine the next state based on the current state and inputs
always_comb begin
    case(current_state)
        OFF: begin
            if(j) next_state = ON;
            else  next_state = OFF;
        end
        ON: begin
            if(k) next_state = OFF;
            else  next_state = ON;
        end
    endcase
end

// State register with asynchronous reset
always_ff @(posedge clk or posedge areset) begin
    if(areset) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

endmodule