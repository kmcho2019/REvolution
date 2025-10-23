module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

// Define the states of the FSM
enum logic [1:0] {
    IDLE,
    START,
    DATA,
    STOP
} state, next_state;

// Counter for data bits
logic [2:0] data_counter;

// Register to store the received data
logic [7:0] data_reg;

// Output signal
logic done_reg;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data_counter <= 3'b000;
        data_reg <= 8'b00000000;
        done_reg <= 1'b0;
    end else begin
        state <= next_state;
        data_counter <= data_counter;
        data_reg <= data_reg;
        done_reg <= 1'b0;

        case (state)
            IDLE: begin
                if (~in) begin
                    next_state <= START;
                end else begin
                    next_state <= IDLE;
                end
            end
            START: begin
                if (~in) begin
                    next_state <= DATA;
                end else begin
                    next_state <= IDLE;
                end
            end
            DATA: begin
                data_reg <= {data_reg[6:0], in};
                if (data_counter == 3'b111) begin
                    next_state <= STOP;
                end else begin
                    data_counter <= data_counter + 1'b1;
                    next_state <= DATA;
                end
            end
            STOP: begin
                if (in) begin
                    done_reg <= 1'b1;
                    next_state <= IDLE;
                end else begin
                    next_state <= STOP;
                end
            end
            default: next_state <= IDLE;
        endcase
    end
end

assign done = done_reg;

endmodule