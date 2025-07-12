module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define states for the FSM using one-hot encoding
logic [2:0] state, next_state;

// Signal to indicate when a message is fully received
logic msg_received, next_msg_received;

always_comb begin
    next_state = state;
    next_msg_received = 0;
    
    case(state)
        3'b001: begin // SEARCH
            if(in[3]) begin
                next_state = 3'b010; // Transition to BYTE1
            end
        end
        3'b010: begin // BYTE1
            next_state = 3'b100; // Transition to BYTE2
        end
        3'b100: begin // BYTE2
            next_state = 3'b001; // Transition back to SEARCH
            next_msg_received = 1; // Set msg_received flag
        end
        default: begin
            next_state = 3'b001; // Reset to SEARCH state
        end
    endcase
end

always_ff @(posedge clk) begin
    if(reset) begin
        state <= 3'b001;
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