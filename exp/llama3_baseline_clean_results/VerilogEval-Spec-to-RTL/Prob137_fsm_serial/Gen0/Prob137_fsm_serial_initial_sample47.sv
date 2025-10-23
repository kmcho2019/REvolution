module TopModule(
    input  clk,
    input  reset,
    input  in,
    output done
);

// Define states
enum logic [2:0] {
    IDLE,
    START,
    DATA,
    STOP
} state, next_state;

// Data storage
logic [7:0] data;

// Counter for data bits
logic [2:0] data_counter;

// Output signal
logic done_reg;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        data <= 8'd0;
        data_counter <= 3'd0;
        done_reg <= 1'b0;
    end else begin
        state <= next_state;
        data <= (state == START || state == DATA) ? {data[6:0], in} : data;
        data_counter <= (state == START || state == DATA) ? data_counter + 1 : 3'd0;
        done_reg <= (state == STOP && in == 1'b1) ? 1'b1 : 1'b0;
    end
end

always_comb begin
    next_state = state;
    case(state)
        IDLE: begin
            if (in == 1'b0) next_state = START;
        end
        START: begin
            next_state = DATA;
        end
        DATA: begin
            if (data_counter == 3'd7) next_state = STOP;
        end
        STOP: begin
            if (in == 1'b1) begin
                next_state = IDLE;
            end
        end
    endcase
end

assign done = done_reg;

endmodule