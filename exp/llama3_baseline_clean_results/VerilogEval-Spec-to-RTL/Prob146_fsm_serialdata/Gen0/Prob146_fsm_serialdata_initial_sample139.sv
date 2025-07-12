module TopModule (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

// Define the states
enum logic [2:0] {
    IDLE,
    START,
    DATA,
    STOP,
    DONE
} state, next_state;

// Data bit counter
logic [2:0] data_counter;

// Data byte register
logic [7:0] data_byte;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data_counter <= 0;
        data_byte <= 0;
    end else begin
        state <= next_state;
        data_counter <= data_counter + (state == DATA) ? 1 : 0;
        data_byte <= (state == DATA) ? {data_byte[6:0], in} : data_byte;
    end
end

always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (~in) begin
                next_state = START;
            end else begin
                next_state = IDLE;
            end
        end
        START: begin
            next_state = DATA;
        end
        DATA: begin
            if (data_counter == 7) begin
                next_state = STOP;
            end else begin
                next_state = DATA;
            end
        end
        STOP: begin
            if (in) begin
                next_state = DONE;
            end else begin
                next_state = STOP;
            end
        end
        DONE: begin
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

assign out_byte = (state == DONE) ? data_byte : 8'bxxxx_xxx;
assign done = (state == DONE) ? 1'b1 : 1'b0;

endmodule