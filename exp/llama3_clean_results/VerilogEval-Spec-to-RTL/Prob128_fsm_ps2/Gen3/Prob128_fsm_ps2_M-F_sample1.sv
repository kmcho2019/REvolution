module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output          done
);

// Define states for the FSM
enum logic [1:0] {
    IDLE,  // Idle state, searching for message start
    COUNT  // Counting state, receiving message bytes
} state, next_state;

// Counter to track the number of bytes received
logic [1:0] byte_count, next_byte_count;

always_comb begin
    next_state = state;
    next_byte_count = byte_count;
    case(state)
        IDLE: begin
            if(in[3]) begin
                next_state = COUNT;
                next_byte_count = 1;
            end
        end
        COUNT: begin
            if(byte_count == 3) begin
                next_state = IDLE;
                next_byte_count = 0;
            end
            else begin
                next_byte_count = byte_count + 1;
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

assign done = (state == COUNT && byte_count == 2);

endmodule