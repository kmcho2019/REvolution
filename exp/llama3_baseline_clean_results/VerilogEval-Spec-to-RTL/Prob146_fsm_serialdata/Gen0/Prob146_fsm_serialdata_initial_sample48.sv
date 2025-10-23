module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

// Define states for the FSM
enum logic [2:0] {
    IDLE,
    START_BIT,
    DATA_BITS,
    STOP_BIT
} state, next_state;

// Counter for data bits
logic [2:0] bit_counter;

// Register for out_byte
logic [7:0] byte_register;

// Output done signal
logic done_signal;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        bit_counter <= 3'b000;
        byte_register <= 8'b0;
        done_signal <= 1'b0;
    end else begin
        state <= next_state;
        bit_counter <= (next_state == DATA_BITS) ? bit_counter + 1 : 3'b000;
        byte_register <= (next_state == DATA_BITS) ? {byte_register[6:0], in} : byte_register;
        done_signal <= (next_state == STOP_BIT && in == 1'b1) ? 1'b1 : 1'b0;
    end
end

always_comb begin
    case (state)
        IDLE: begin
            if (in == 1'b0) begin
                next_state = START_BIT;
            end else begin
                next_state = IDLE;
            end
        end
        START_BIT: begin
            next_state = DATA_BITS;
        end
        DATA_BITS: begin
            if (bit_counter == 3'b111) begin
                next_state = STOP_BIT;
            end else begin
                next_state = DATA_BITS;
            end
        end
        STOP_BIT: begin
            if (in == 1'b1) begin
                next_state = IDLE;
            end else begin
                next_state = STOP_BIT;
            end
        end
        default: next_state = IDLE;
    endcase
end

assign out_byte = byte_register;
assign done = done_signal;

endmodule