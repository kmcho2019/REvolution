module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output          done
);

// Define states for the FSM
enum logic [1:0] {IDLE, MSGReceived} state, next_state;

// Shift register to store the last three bytes received
logic [23:0] byte_register, next_byte_register;

always_comb begin
    next_state = state;
    next_byte_register = byte_register;
    done = 0;
    
    case(state)
        IDLE: begin
            if(in[3]) begin // Transition to MSGReceived if in[3] = 1
                next_state = MSGReceived;
                next_byte_register = {in, 16'd0}; // Shift in the first byte
            end
        end
        MSGReceived: begin
            next_byte_register = {byte_register[15:0], in}; // Shift in the next byte
            
            if(byte_register[23:16]!= 0) begin // Check if this is the third byte
                done = 1; // Assert 'done' signal
                next_state = IDLE; // Transition back to IDLE
                next_byte_register = 0; // Reset shift register
            end
        end
    endcase
end

always_ff @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        byte_register <= 0;
    end
    else begin
        state <= next_state;
        byte_register <= next_byte_register;
    end
end

endmodule