module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    typedef enum reg [2:0] {
        IDLE = 3'd0,
        START = 3'd1,
        DATA = 3'd2,
        STOP = 3'd3,
        RECOVER = 3'd4
    } state_t;

    state_t state, next_state;
    reg [3:0] bit_count; // to count 8 data bits

    reg [7:0] data_shift;

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 4'd0;
            data_shift <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default done low; will assert when byte done

            case(state)
                IDLE: begin
                    if (in == 1'b0) // start bit detected
                        bit_count <= 4'd0;
                end
                START: begin
                    // nothing to do here except next_state logic
                end
                DATA: begin
                    // Shift in data bits LSB first
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 1;
                end
                STOP: begin
                    if (in == 1'b1) begin
                        out_byte <= data_shift;
                        done <= 1'b1;
                    end
                end
                RECOVER: begin
                    // no operation, waiting for stop bit 1
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        case(state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = START;
                else
                    next_state = IDLE;
            end
            START: begin
                if (in == 1'b0)
                    next_state = DATA;
                else
                    next_state = IDLE; // false start bit, go back idle
            end
            DATA: begin
                if (bit_count == 4'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end
            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = RECOVER; // bad stop bit, wait for correct stop bit
            end
            RECOVER: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = RECOVER;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule