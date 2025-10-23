module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states
parameter A = 1'b0;
parameter B = 1'b1;

reg [0:0] state; // Use a reg to hold the current state
reg [0:0] next_state; // Use a reg to hold the next state

// Asynchronous reset
always @(areset or state or in) begin
    if(areset) begin
        state = B;
    end else begin
        // Combinational logic for next state and output
        case(state)
            A: begin
                if(!in) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
            end
            B: begin
                if(!in) begin
                    next_state = A;
                end else begin
                    next_state = B;
                end
            end
            default: next_state = B; // Default to state B
        endcase
    end
end

// Sequential logic for state update on clock edge
always @(posedge clk or negedge areset) begin
    if(!areset) begin
        state = B; // Reset state to B on asynchronous reset
    end else begin
        state = next_state;
    end
end

// Output logic (Moore machine output depends only on state)
always @(state) begin
    case(state)
        A: out = 0;
        B: out = 1;
        default: out = 1; // Default output to 1 (state B)
    endcase
end

endmodule