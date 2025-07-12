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

// Flag to indicate when the third byte has been received
logic msg_received, next_msg_received;

always_comb begin
    next_state = state;
    next_byte_count = byte_count;
    next_msg_received = msg_received;
    
    case(state)
        IDLE: begin
            if(in[3]) begin
                next_state = COUNTING;
                next_byte_count = 1;
            end
        end
        COUNTING: begin
            if(byte_count < 2) begin
                next_byte_count = byte_count + 1;
            end else begin
                next_state = IDLE;
                next_byte_count = 0;
                next_msg_received = 1;
            end
        end
    endcase
end

always_ff @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        byte_count <= 0;
        msg_received <= 0;
    end else begin
        state <= next_state;
        byte_count <= next_byte_count;
        msg_received <= next_msg_received;
    end
end

assign done = msg_received;

endmodule