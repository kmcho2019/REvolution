module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    typedef enum reg [1:0] {
        IDLE = 2'd0,
        DATA = 2'd1,
        STOP = 2'd2,
        WAIT_STOP = 2'd3
    } state_t;

    reg [1:0] state, next_state;
    reg [3:0] bit_count; // to count 8 bits
    reg [7:0] data_shift;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data_shift <= 8'd0;
            done <= 0;
        end else begin
            state <= next_state;
            done <= 0; // default no done

            case (state)
                IDLE: begin
                    bit_count <= 0;
                    data_shift <= 8'd0;
                    if (in == 1'b0) begin
                        // start bit detected
                        // next state handled below
                    end
                end

                DATA: begin
                    // shift in data bits LSB first
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 1;
                end

                STOP: begin
                    // done logic handled below
                end

                WAIT_STOP: begin
                    // wait for stop bit (in == 1)
                end
            endcase

            // done assigned below for state STOP with correct stop bit
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = DATA;
            end

            DATA: begin
                if (bit_count == 4'd8)
                    next_state = STOP;
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
            end
        endcase
    end

    // done signal generation
    always @(posedge clk) begin
        if (!reset && state == STOP && in == 1'b1) begin
            done <= 1'b1;
        end
    end

endmodule