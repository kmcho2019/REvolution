module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg done
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE       = 2'd0,
        RECEIVE    = 2'd1,
        CHECK_STOP = 2'd2,
        WAIT_STOP  = 2'd3
    } state_t;

    state_t state, next_state;
    reg [2:0] bit_count; // Counts bits 0-7

    // Sequential logic: state, bit_count, done
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // Default done to 0 every cycle, except in CHECK_STOP when done is asserted
            done <= 1'b0;

            case(state)
                IDLE: bit_count <= 3'd0;
                RECEIVE: bit_count <= bit_count + 3'd1;
                CHECK_STOP: ; // bit_count stays same
                WAIT_STOP: bit_count <= 3'd0;
            endcase

            // Assert done for one cycle if stop bit valid
            if (state == CHECK_STOP && in == 1'b1)
                done <= 1'b1;
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state;

        case(state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;
            end
            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP;
            end
            CHECK_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;      // Valid stop bit: go idle after done pulse
                else
                    next_state = WAIT_STOP; // Invalid stop bit: wait for line idle
            end
            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
            end
        endcase
    end

endmodule