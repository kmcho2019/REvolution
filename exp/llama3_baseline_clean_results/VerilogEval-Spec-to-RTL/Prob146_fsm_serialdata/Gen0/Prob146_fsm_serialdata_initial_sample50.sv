module TopModule (
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

// Define states for the FSM
enum logic [1:0] {IDLE, START, DATA, STOP} state, next_state;

// Counter to keep track of the number of data bits received
logic [2:0] data_cnt;

// Shift register to construct the byte being received
logic [7:0] byte_reg;

always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (!in) // Start bit detected
                next_state = START;
            else
                next_state = IDLE; // Remain in idle
        end
        START: begin
            next_state = DATA; // Proceed to receive data bits
            data_cnt = 0;
        end
        DATA: begin
            if (data_cnt == 7) begin // All 8 data bits received
                next_state = STOP;
            end else begin
                next_state = DATA;
            end
        end
        STOP: begin
            if (in) begin // Stop bit detected, transition back to idle
                next_state = IDLE;
            end else begin // Incorrect stop bit, remain in stop
                next_state = STOP;
            end
        end
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        byte_reg <= 8'd0;
        data_cnt <= 3'd0;
    end else begin
        state <= next_state;
        
        case (state)
            START, DATA: begin
                // Construct the byte as data bits are received, shifting in the new bit
                byte_reg <= {byte_reg[6:0], in};
                if (state == DATA)
                    data_cnt <= data_cnt + 1;
            end
        endcase
    end
end

// Assert done when the FSM finds a stop bit after receiving a byte
assign done = (state == STOP && in);

// out_byte is valid when done is 1
assign out_byte = (done) ? byte_reg : 8'd0;

endmodule