module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output          done
);

// Define states for the FSM
enum logic [1:0] {IDLE, COUNTING} state;

// Counter for bytes received after message start
logic [1:0] byte_count;

always_comb begin
    case(state)
        IDLE: begin
            if(in[3]) begin // Transition to COUNTING if in[3] = 1
                state = COUNTING;
                byte_count = 1; // Start counting from 1
            end else begin
                state = IDLE;
                byte_count = 0;
            end
        end
        COUNTING: begin
            if(byte_count < 2) begin // If not yet received 3 bytes
                state = COUNTING;
                byte_count = byte_count + 1; // Increment counter
            end else begin
                state = IDLE; // Transition back to IDLE
                byte_count = 0; // Reset counter
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
        if(state == COUNTING && byte_count == 2) begin
            done <= 1;
        end else begin
            done <= 0;
        end
    end
end

endmodule