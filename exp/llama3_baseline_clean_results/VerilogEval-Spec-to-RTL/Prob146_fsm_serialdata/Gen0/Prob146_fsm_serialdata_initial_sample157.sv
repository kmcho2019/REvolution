module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

// Define states
enum logic [2:0] {IDLE, START, DATA, STOP, WAIT_STOP} state, next_state;

// Counter to keep track of the bit position within the byte
logic [2:0] bit_pos;

// Register to store the received byte
logic [7:0] byte_reg;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        bit_pos <= 3'b000;
        byte_reg <= 8'b0;
        out_byte <= 8'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (in == 1'b0) begin
                    state <= START;
                    bit_pos <= 3'b000;
                end else begin
                    state <= IDLE;
                end
            end
            START: begin
                state <= DATA;
                bit_pos <= 3'b000;
            end
            DATA: begin
                byte_reg[bit_pos] <= in;
                bit_pos <= bit_pos + 1'b1;
                if (bit_pos == 3'b111) begin
                    state <= STOP;
                end else begin
                    state <= DATA;
                end
            end
            STOP: begin
                if (in == 1'b1) begin
                    state <= IDLE;
                    out_byte <= byte_reg;
                    done <= 1'b1;
                end else begin
                    state <= WAIT_STOP;
                end
            end
            WAIT_STOP: begin
                if (in == 1'b1) begin
                    state <= IDLE;
                end else begin
                    state <= WAIT_STOP;
                end
            end
        endcase
    end
end

// Combinational logic for output
always_comb begin
    done <= (state == STOP && in == 1'b1);
end

endmodule