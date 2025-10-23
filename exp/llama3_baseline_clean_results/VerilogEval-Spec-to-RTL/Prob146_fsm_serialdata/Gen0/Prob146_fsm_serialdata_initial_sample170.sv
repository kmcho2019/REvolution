module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

// Define states
enum logic [2:0] {
    IDLE,
    START_BIT,
    DATA_BITS,
    STOP_BIT,
    WAIT_FOR_STOP
} state, next_state;

// Define counter for data bits
logic [2:0] data_bit_counter;

// Define register for output byte
logic [7:0] out_byte_reg;

always_comb begin
    // Initialize next state and output signals
    next_state = state;
    done = 1'b0;

    case(state)
        IDLE: begin
            if (~in) begin
                next_state = START_BIT;
            end
        end
        START_BIT: begin
            if (~in) begin
                next_state = DATA_BITS;
            end else if (in) begin
                next_state = IDLE;
            end
        end
        DATA_BITS: begin
            if (data_bit_counter == 8'd8) begin
                next_state = STOP_BIT;
            end
        end
        STOP_BIT: begin
            if (in) begin
                done = 1'b1;
                next_state = IDLE;
            end else begin
                next_state = WAIT_FOR_STOP;
            end
        end
        WAIT_FOR_STOP: begin
            if (in) begin
                next_state = IDLE;
            end
        end
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data_bit_counter <= 3'd0;
        out_byte_reg <= 8'd0;
    end else begin
        state <= next_state;
        case(state)
            DATA_BITS: begin
                if (data_bit_counter < 8'd8) begin
                    out_byte_reg[data_bit_counter] <= in;
                    data_bit_counter <= data_bit_counter + 1'b1;
                end
            end
            STOP_BIT, WAIT_FOR_STOP: begin
                if (next_state == IDLE) begin
                    data_bit_counter <= 3'd0;
                end
            end
        endcase
    end
end

assign out_byte = (done)? out_byte_reg : 8'd0;

endmodule