module TopModule(
    input clk,
    input a,
    output reg q
);

// Define the states
enum logic [0:0] {HIGH_STATE, LOW_STATE} current_state, next_state;

// Initialize the current state
initial current_state = HIGH_STATE;

// Define the state transitions
always @(posedge clk) begin
    case (current_state)
        HIGH_STATE: begin
            if (a) begin
                next_state = LOW_STATE;
            end else begin
                next_state = HIGH_STATE;
            end
        end
        LOW_STATE: begin
            if (!a) begin
                next_state = HIGH_STATE;
            end else begin
                next_state = LOW_STATE;
            end
        end
        default: next_state = HIGH_STATE;
    endcase
    
    // Update the current state
    current_state <= next_state;
    
    // Determine the output q based on the current state
    case (current_state)
        HIGH_STATE: q <= 1'b1;
        LOW_STATE: q <= 1'b0;
        default: q <= 1'b1;
    endcase
end

endmodule