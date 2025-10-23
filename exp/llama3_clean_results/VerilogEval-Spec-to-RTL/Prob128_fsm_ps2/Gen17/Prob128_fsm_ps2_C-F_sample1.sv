module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define states for the FSM
logic [1:0] state, next_state;

// Signal to indicate when a message is fully received
logic msg_received, next_msg_received;

always_comb begin
    next_state = state;
    next_msg_received = 0;
    
    case(state)
        2'd0: begin // SEARCH
            if(in[3]) begin
                next_state = 2'd1; // Transition to BYTE1
            end
        end
        2'd1: begin // BYTE1
            next_state = 2'd2; // Transition to BYTE2
        end
        2'd2: begin // BYTE2
            next_state = 2'd0; // Transition back to SEARCH
            next_msg_received = 1; // Set msg_received flag
        end
    endcase
end

always_ff @(posedge clk) begin
    if(reset) begin
        state <= 2'd0;
        msg_received <= 0;
        done <= 0;
    end
    else begin
        state <= next_state;
        msg_received <= next_msg_received;
        if(msg_received)
            done <= 1;
        else
            done <= 0;
    end
end

endmodule