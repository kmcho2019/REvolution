module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Define the states
enum logic [0:0] {OFF, ON} current_state, next_state;

// Sequential logic for state transition
always_ff @(posedge clk) begin
    if(reset) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic for next state and output
always_comb begin
    case(current_state)
        OFF: begin
            if(j) begin
                next_state = ON;
            end else begin
                next_state = OFF;
            end
        end
        ON: begin
            if(k) begin
                next_state = OFF;
            end else begin
                next_state = ON;
            end
        end
        default: next_state = OFF; // Default to OFF for any unexpected state
    endcase
end

// Assign output based on current state
assign out = (current_state == ON) ? 1'b1 : 1'b0;

endmodule