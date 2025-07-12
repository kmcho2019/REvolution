module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

// Define the states
enum {OFF, ON} current_state, next_state;

// Combinational logic for next state
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
        default: next_state = OFF; // default to OFF for any other state
    endcase
end

// Sequential logic for state update and reset
always_ff @(posedge clk or posedge areset) begin
    if(areset) begin
        current_state <= OFF; // Asynchronous reset to OFF state
    end else begin
        current_state <= next_state;
    end
end

// Assign output based on current state (Moore machine)
always_comb begin
    case(current_state)
        OFF: out = 0;
        ON:  out = 1;
        default: out = 0; // default output for any other state
    endcase
end

endmodule