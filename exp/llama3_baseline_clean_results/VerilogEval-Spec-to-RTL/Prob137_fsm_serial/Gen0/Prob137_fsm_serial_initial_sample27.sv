module TopModule(
    input  clk,
    input  reset,
    input  in,
    output done
);

// Define the states
enum logic [1:0] {
    IDLE,
    DATA,
    STOP,
    ERROR
} state, next_state;

// Counter for data bits
logic [2:0] data_cnt;

// Shift register for data bits
logic [7:0] data_reg;

// Signal to indicate done
logic done_sig;

always_comb begin
    // Default values
    next_state = state;
    done_sig = 1'b0;

    case(state)
        IDLE: begin
            if (~in) begin
                // Start bit received, transition to DATA state
                next_state = DATA;
            end
        end
        DATA: begin
            if (data_cnt == 8) begin
                // 8 data bits received, transition to STOP state
                next_state = STOP;
            end else begin
                // Increment data counter
                data_cnt = data_cnt + 1'b1;
                // Shift data register
                data_reg = {data_reg[6:0], in};
            end
        end
        STOP: begin
            if (in) begin
                // Stop bit received, assert done signal and transition to IDLE state
                done_sig = 1'b1;
                next_state = IDLE;
            end else begin
                // Stop bit not received, transition to ERROR state
                next_state = ERROR;
            end
        end
        ERROR: begin
            if (in) begin
                // Stop bit received, transition to IDLE state
                next_state = IDLE;
            end
        end
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data_cnt <= 3'b000;
        data_reg <= 8'b00000000;
    end else begin
        state <= next_state;
        if (state == DATA) begin
            if (data_cnt == 8) begin
                data_cnt <= 3'b000;
            end
        end else if (state == IDLE) begin
            data_cnt <= 3'b000;
            data_reg <= 8'b00000000;
        end
    end
end

assign done = done_sig;

endmodule