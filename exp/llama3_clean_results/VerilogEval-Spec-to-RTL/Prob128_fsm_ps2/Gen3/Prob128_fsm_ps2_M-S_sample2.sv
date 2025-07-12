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
} state;

// Counter to track the number of bytes received
logic [1:0] byte_count;

always_ff @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        byte_count <= 0;
    end
    else begin
        case(state)
            IDLE: begin
                if(in[3]) begin
                    state <= COUNT;
                    byte_count <= 1;
                end
            end
            COUNT: begin
                byte_count <= byte_count + 1;
                if(byte_count == 3) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

assign done = (state == COUNT && byte_count == 3);

endmodule