module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

// States
enum logic [2:0] {
    IDLE,
    START,
    DATA,
    STOP,
    DONE
} state, next_state;

// Internal signals
logic [7:0] byte;
logic [2:0] bit_count;
logic stop_bit;

// FSM state register
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// FSM next state logic
always_comb begin
    case (state)
        IDLE: begin
            if (!in) begin
                next_state = START;
            end else begin
                next_state = IDLE;
            end
        end
        START: begin
            next_state = DATA;
        end
        DATA: begin
            if (bit_count == 8) begin
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

// Bit counter
always_ff @(posedge clk) begin
    if (reset || state == IDLE || state == DONE) begin
        bit_count <= 0;
    end else if (state == DATA) begin
        bit_count <= bit_count + 1;
    end
end

// Shift register (byte)
always_ff @(posedge clk) begin
    if (reset || state == IDLE || state == DONE) begin
        byte <= 0;
    end else if (state == DATA) begin
        byte <= {byte[6:0], in};
    end
end

// Output logic
assign out_byte = (state == DONE) ? byte : 8'b0;
assign done = (state == DONE);

endmodule