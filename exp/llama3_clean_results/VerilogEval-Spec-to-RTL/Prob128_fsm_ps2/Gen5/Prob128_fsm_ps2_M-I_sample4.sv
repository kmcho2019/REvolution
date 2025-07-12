module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output          done
);

// Define states for the FSM
enum logic [1:0] {IDLE, COUNTING} state, next_state;

// Counter for bytes received after message start
logic [1:0] byte_count, next_byte_count;

// Signal to indicate when a message is fully received
logic msg_received, next_msg_received;

always_comb begin
    next_state = state;
    next_byte_count = byte_count;
    next_msg_received = 0;
    
    case(state)
        IDLE: begin
            if(in[3]) begin // Transition to COUNTING if in[3] = 1
                next_state = COUNTING;
                next_byte_count = 1; // Start counting from 1
            end
        end
        COUNTING: begin
            if(byte_count < 2) begin // If not yet received 3 bytes
                next_byte_count = byte_count + 1; // Increment counter
            end else begin
                next_msg_received = 1; // Set msg_received flag
                next_state = IDLE; // Transition back to IDLE
                next_byte_count = 0; // Reset counter
            end
        end
    endcase
end

always_ff @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        byte_count <= 0;
        msg_received <= 0;
    end
    else begin
        state <= next_state;
        byte_count <= next_byte_count;
        msg_received <= next_msg_received;
    end
end

// Assert 'done' when a message is fully received
assign done = msg_received;

endmodule