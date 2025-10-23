module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

// States
enum {IDLE, START, DATA, STOP} state, next_state;

// Data bit counter
reg [2:0] bit_counter;

// Data byte register
reg [7:0] data_byte;

always @(*) begin
    // Defaults
    next_state = state;
    done = 0;

    case(state)
        IDLE: begin
            if (~in) begin // Start bit detected
                next_state = START;
            end else begin
                next_state = IDLE;
            end
        end
        START: begin
            next_state = DATA;
            data_byte = 0;
            bit_counter = 0;
        end
        DATA: begin
            data_byte = data_byte >> 1; // Shift in the new bit
            data_byte[0] = in; // Put the input bit in the LSB
            if (bit_counter == 7) begin // 8 bits received
                next_state = STOP;
            end else begin
                next_state = DATA;
                bit_counter = bit_counter + 1;
            end
        end
        STOP: begin
            if (in) begin // Stop bit detected
                next_state = IDLE;
                done = 1;
            end else begin // No stop bit, wait for stop bit
                next_state = STOP;
            end
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        out_byte <= 0;
    end else begin
        state <= next_state;
        if (done) begin
            out_byte <= data_byte;
        end
    end
end

endmodule