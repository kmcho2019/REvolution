module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state; // Current state of the machine (0 - A, 1 - B)
reg [0:0] next_state; // Next state of the machine

// Asynchronous reset
always @(areset or state or in) begin
    if(areset) begin
        state <= 1; // Reset to state B
    end else begin
        case(state)
            0: begin // State A
                if(!in) begin
                    next_state = 1; // A (0) --0--> B
                end else begin
                    next_state = 0; // A (0) --1--> A
                end
            end
            1: begin // State B
                if(!in) begin
                    next_state = 0; // B (1) --0--> A
                end else begin
                    next_state = 1; // B (1) --1--> B
                end
            end
            default: next_state = 1; // Default to state B
        endcase
    end
end

// Synchronous update of state on clock edge
always @(posedge clk) begin
    state <= next_state;
end

// Output is solely determined by the current state (Moore machine)
always @(state) begin
    case(state)
        0: out = 0; // State A
        1: out = 1; // State B
        default: out = 1; // Default to state B
    endcase
end

endmodule