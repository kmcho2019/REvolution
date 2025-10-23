module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define states for the FSM
enum logic [1:0] {SEARCH, BYTE1, BYTE2} state, next_state;

// Signal to indicate when a message is fully received
logic msg_received, next_msg_received;

always_comb begin
    next_state = state;
    next_msg_received = 0;
    
    case(state)
        SEARCH: begin
            if(in[3]) begin
                next_state = BYTE1;
            end
        end
        BYTE1: begin
            next_state = BYTE2;
        end
        BYTE2: begin
            next_state = SEARCH;
            next_msg_received = 1; // Set msg_received flag
        end
    endcase
end

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