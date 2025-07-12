module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

// Define the states of the FSM
enum {IDLE, START, DATA, STOP} state, next_state;

// Register to store the received byte
logic [7:0] byte;

// Counter for the data bits
logic [2:0] bit_count;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        out_byte <= 8'b0;
        done <= 1'b0;
        byte <= 8'b0;
        bit_count <= 3'b0;
    end else begin
        case (state)
            IDLE: begin
                if (in == 1'b0) begin
                    state <= START;
                    bit_count <= 3'b1;
                end else begin
                    state <= IDLE;
                end
            end
            START: begin
                byte[0] <= in;
                state <= DATA;
            end
            DATA: begin
                if (bit_count == 8) begin
                    state <= STOP;
                end else begin
                    byte[bit_count] <= in;
                    bit_count <= bit_count + 1;
                end
            end
            STOP: begin
                if (in == 1'b1) begin
                    state <= IDLE;
                    out_byte <= byte;
                    done <= 1'b1;
                end else begin
                    state <= IDLE;
                end
            end
            default: state <= IDLE;
        endcase
        if (state == IDLE || state == START || state == DATA) begin
            done <= 1'b0;
        end
    end
end

endmodule