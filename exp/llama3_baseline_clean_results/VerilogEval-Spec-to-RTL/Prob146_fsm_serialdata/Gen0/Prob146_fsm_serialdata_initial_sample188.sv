module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

    // Enum for states
    enum logic [2:0] {IDLE, DATA RECEIVE, STOP_VERIFY, DONE} state, next_state;

    // Data byte and bit counter
    logic [7:0] byte;
    logic [2:0] bit_counter;

    // Sequential logic
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            out_byte <= 8'b0;
            done <= 1'b0;
            byte <= 8'b0;
            bit_counter <= 3'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (!in) begin // Start bit detected
                        state <= DATA_RECEIVE;
                        bit_counter <= 3'b0;
                    end else begin
                        state <= IDLE;
                    end
                end
                DATA_RECEIVE: begin
                    byte[bit_counter] <= in; // Least significant bit first
                    bit_counter <= bit_counter + 1'b1;
                    if (bit_counter == 8) begin
                        state <= STOP_VERIFY;
                    end else begin
                        state <= DATA_RECEIVE;
                    end
                end
                STOP_VERIFY: begin
                    if (in) begin // Stop bit detected
                        out_byte <= {byte[7], byte[6], byte[5], byte[4], byte[3], byte[2], byte[1], byte[0]}; // Reverse byte order for output
                        state <= DONE;
                        done <= 1'b1;
                    end else begin
                        state <= STOP_VERIFY;
                    end
                end
                DONE: begin
                    done <= 1'b0;
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule