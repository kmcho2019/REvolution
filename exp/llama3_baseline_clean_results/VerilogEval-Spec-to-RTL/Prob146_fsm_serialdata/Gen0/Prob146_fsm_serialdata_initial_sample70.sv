module TopModule (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

// Enumerating the states of the FSM
enum logic [2:0] {
    IDLE,
    START_BIT,
    DATA_BITS,
    STOP_BIT
} state, next_state;

// Register to store the received byte
logic [7:0] byte_reg;

// Register to store the received data bits so far
logic [7:0] data_reg;

// Counter to count the number of data bits received so far
logic [2:0] bit_counter;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        out_byte <= 8'b0;
        done <= 1'b0;
        byte_reg <= 8'b0;
        data_reg <= 8'b0;
        bit_counter <= 3'b0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                // Don't care about the output
            end
            START_BIT: begin
                data_reg <= 8'b0;
                bit_counter <= 3'b0;
            end
            DATA_BITS: begin
                // Shift the received bits to the left and add the new bit
                data_reg <= {data_reg[6:0], in};
                bit_counter <= bit_counter + 1'b1;
            end
            STOP_BIT: begin
                done <= 1'b1;
                out_byte <= data_reg;
            end
            default: begin
                // Don't care about the output
            end
        endcase
    end
end

// Combinational logic
always_comb begin
    case (state)
        IDLE: begin
            if (in == 1'b0) begin
                next_state = START_BIT;
            end else begin
                next_state = IDLE;
            end
            done = 1'b0;
        end
        START_BIT: begin
            next_state = DATA_BITS;
            done = 1'b0;
        end
        DATA_BITS: begin
            if (bit_counter == 3'b111) begin
                next_state = STOP_BIT;
            end else begin
                next_state = DATA_BITS;
            end
            done = 1'b0;
        end
        STOP_BIT: begin
            if (in == 1'b1) begin
                next_state = IDLE;
            end else begin
                next_state = STOP_BIT;
            end
        end
        default: begin
            next_state = IDLE;
            done = 1'b0;
        end
    endcase
end

endmodule