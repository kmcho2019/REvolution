module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define states for the FSM
logic [1:0] state, next_state;
logic [1:0] byte_count, next_byte_count;

always_comb begin
    next_state = state;
    next_byte_count = byte_count;
    done = 0;
    
    case(state)
        2'd0: begin // SEARCH
            if(in[3]) begin
                next_state = 2'd1; // Transition to BYTE_COUNT
                next_byte_count = 1; // Reset byte count
            end
        end
        2'd1: begin // BYTE_COUNT
            next_byte_count = byte_count + 1; // Increment byte count
            if(byte_count == 2) begin // If three bytes are received
                next_state = 2'd0; // Transition back to SEARCH
                done = 1; // Assert done signal
            end
        end
        default: next_state = 2'd0; // default to SEARCH state
    endcase
end

always_ff @(posedge clk) begin
    if(reset) begin
        state <= 2'd0;
        byte_count <= 0;
    end
    else begin
        state <= next_state;
        byte_count <= next_byte_count;
    end
end

endmodule