module TopModule (
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

// Define the states
enum logic [2:0] {
    IDLE,
    START,
    DATA,
    STOP,
    ERROR
} state, next_state;

// Internal registers
logic [2:0] bit_count;
logic [7:0] data_byte;

// Combinational logic for next state and outputs
always_comb begin
    next_state = state;
    done = 1'b0;
    case (state)
        IDLE: begin
            if (~in) next_state = START;
        end
        START: begin
            next_state = DATA;
        end
        DATA: begin
            if (bit_count == 8) next_state = STOP;
        end
        STOP: begin
            if (in) begin
                next_state = IDLE;
                done = 1'b1;
            end else begin
                next_state = ERROR;
            end
        end
        ERROR: begin
            if (in) next_state = IDLE;
        end
    endcase
end

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        bit_count <= 3'b0;
        out_byte <= 8'b0;
    end else begin
        case (next_state)
            IDLE: begin
                state <= next_state;
                bit_count <= 3'b0;
            end
            START: begin
                state <= next_state;
                bit_count <= 3'b0;
            end
            DATA: begin
                state <= next_state;
                bit_count <= bit_count + 1'b1;
                data_byte[bit_count - 1] <= in;
            end
            STOP: begin
                state <= next_state;
                out_byte <= data_byte;
            end
            ERROR: begin
                state <= next_state;
            end
        endcase
    end
end

endmodule