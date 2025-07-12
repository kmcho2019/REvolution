module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // Define states with typedef enum for readability
    typedef enum reg [1:0] {
        IDLE       = 2'd0,
        RECEIVE    = 2'd1,
        CHECK_STOP = 2'd2,
        WAIT_STOP  = 2'd3
    } state_t;

    state_t state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Combinational logic for next state
    always @(*) begin
        case(state)
            IDLE:       next_state = (in == 1'b0) ? RECEIVE : IDLE;
            RECEIVE:    next_state = (bit_count == 3'd7) ? CHECK_STOP : RECEIVE;
            CHECK_STOP: next_state = (in == 1'b1) ? IDLE : WAIT_STOP;
            WAIT_STOP:  next_state = (in == 1'b1) ? IDLE : WAIT_STOP;
            default:    next_state = IDLE;
        endcase
    end

    // Determine enables for shift and count increment
    wire receive_enable = (state == RECEIVE);
    wire count_reset    = (state == IDLE) || (state == CHECK_STOP) || (state == WAIT_STOP);
    wire shift_reset    = count_reset;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            
            // Default done low; only set high in CHECK_STOP with valid stop bit
            done <= 1'b0;

            if (count_reset)
                bit_count <= 3'd0;
            else if (receive_enable)
                bit_count <= bit_count + 1;

            if (shift_reset)
                shift_reg <= 8'd0;
            else if (receive_enable)
                // Shift right, new bit in MSB to maintain LSB-first order
                shift_reg <= {in, shift_reg[7:1]};

            if (state == CHECK_STOP && in == 1'b1)
                done <= 1'b1;
        end
    end

endmodule