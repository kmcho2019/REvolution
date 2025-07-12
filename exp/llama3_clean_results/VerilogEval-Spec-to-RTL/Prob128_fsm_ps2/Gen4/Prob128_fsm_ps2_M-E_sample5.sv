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

always_comb begin
    next_state = state;
    next_byte_count = byte_count;
    case(state)
        IDLE: begin
            if(in[3]) begin // Transition to COUNTING if in[3] = 1
                next_state = COUNTING;
                next_byte_count = 1; // Start counting from 1
            end
        end
        COUNTING: begin
            next_byte_count = byte_count + 1; // Increment counter
            if(byte_count == 2) begin // If third byte is received
                next_state = IDLE; // Transition back to IDLE
            end
        end
    endcase
end

always_ff @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        byte_count <= 0;
    end
    else begin
        state <= next_state;
        byte_count <= next_byte_count;
    end
end

// Assert 'done' when the third byte is received
assign done = (state == COUNTING && byte_count == 2);

endmodule