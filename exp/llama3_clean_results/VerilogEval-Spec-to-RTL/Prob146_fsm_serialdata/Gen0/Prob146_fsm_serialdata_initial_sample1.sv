module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

// Define the states of the FSM
enum logic [3:0] {IDLE, START, DATA0, DATA1, DATA2, DATA3, DATA4, DATA5, DATA6, DATA7, STOP} state;

// Internal register to store the received byte
logic [7:0] byte;

// Internal signal to indicate when a stop bit is detected
logic stop_bit_detected;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        byte <= 8'd0;
        stop_bit_detected <= 1'b0;
        done <= 1'b0;
        out_byte <= 8'd0;
    end else begin
        case (state)
            IDLE: begin
                if (~in) begin // Start bit detected
                    state <= START;
                end else begin
                    state <= IDLE;
                end
            end
            START: begin
                byte[0] <= in; // Store the first bit of the byte
                state <= DATA1;
            end
            DATA1: begin
                byte[1] <= in; // Store the second bit of the byte
                state <= DATA2;
            end
            DATA2: begin
                byte[2] <= in; // Store the third bit of the byte
                state <= DATA3;
            end
            DATA3: begin
                byte[3] <= in; // Store the fourth bit of the byte
                state <= DATA4;
            end
            DATA4: begin
                byte[4] <= in; // Store the fifth bit of the byte
                state <= DATA5;
            end
            DATA5: begin
                byte[5] <= in; // Store the sixth bit of the byte
                state <= DATA6;
            end
            DATA6: begin
                byte[6] <= in; // Store the seventh bit of the byte
                state <= DATA7;
            end
            DATA7: begin
                byte[7] <= in; // Store the eighth bit of the byte
                state <= STOP;
            end
            STOP: begin
                if (in) begin // Stop bit detected
                    done <= 1'b1;
                    out_byte <= byte;
                    state <= IDLE;
                end else begin // Incorrect stop bit, wait for stop bit
                    state <= STOP;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

always_comb begin
    if (state == STOP && in) begin
        done = 1'b1;
    end else begin
        done = 1'b0;
    end
end

endmodule