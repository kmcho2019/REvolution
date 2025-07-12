module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg current_state; // current state of the FSM
reg next_state;    // next state of the FSM

// Define the current state and output
always @(*) begin
    case (current_state)
        1'b0: out = 1'b0; // State A
        1'b1: out = 1'b1; // State B
        default: out = 1'bx;
    endcase
end

// Define the state transitions
always @(*) begin
    case (current_state)
        1'b0: begin // State A
            case (in)
                1'b0: next_state = 1'b1; // State A to State B on 0
                1'b1: next_state = 1'b0; // State A to State A on 1
                default: next_state = 1'bx;
            endcase
        end
        1'b1: begin // State B
            case (in)
                1'b0: next_state = 1'b0; // State B to State A on 0
                1'b1: next_state = 1'b1; // State B to State B on 1
                default: next_state = 1'bx;
            endcase
        end
        default: next_state = 1'bx;
    endcase
end

// Update the current state on clock edge
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 1'b1; // Asynchronous reset to state B
    end else begin
        current_state <= next_state;
    end
end

endmodule