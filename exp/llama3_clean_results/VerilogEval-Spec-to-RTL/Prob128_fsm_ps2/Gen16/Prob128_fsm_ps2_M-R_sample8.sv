module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define states for the FSM as an enumeration
typedef enum logic [1:0] {
    SEARCH,
    BYTE1,
    BYTE2
} state_t;

// Current and next state
state_t state, next_state;

// Signal to indicate when a message is fully received
logic msg_received, next_msg_received;

// Combinational logic for state transitions
always_comb begin
    next_state = state;
    next_msg_received = 0;
    
    case(state)
        SEARCH: begin
            if(in[3]) begin
                next_state = BYTE1; // Transition to BYTE1
            end
        end
        BYTE1: begin
            next_state = BYTE2; // Transition to BYTE2
        end
        BYTE2: begin
            next_state = SEARCH; // Transition back to SEARCH
            next_msg_received = 1; // Set msg_received flag
        end
    endcase
end

// Sequential logic for state and msg_received updates
always_ff @(posedge clk) begin
    if(reset) begin
        state <= SEARCH;
        msg_received <= 0;
    end
    else begin
        state <= next_state;
        msg_received <= next_msg_received;
    end
end

// Assert 'done' when a message is fully received
assign done = msg_received;

endmodule