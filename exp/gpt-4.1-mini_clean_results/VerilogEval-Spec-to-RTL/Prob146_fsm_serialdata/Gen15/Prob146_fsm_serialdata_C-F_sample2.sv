module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // FSM states encoded with typedef enum for clarity and compact 2-bit binary encoding
    typedef enum reg [1:0] {
        IDLE      = 2'b00,
        RECEIVE   = 2'b01,
        CHECK_STOP= 2'b10,
        RECOVER   = 2'b11
    } state_t;

    state_t state, next_state;

    reg [7:0] data_shift;
    reg [2:0] bit_count;

    // Signal indicating when to update bit_count and data_shift
    wire receive_enable = (state == RECEIVE);

    // Sequential: State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Sequential: bit_count increments only during RECEIVE, resets otherwise
    always @(posedge clk) begin
        if (reset)
            bit_count <= 3'd0;
        else if (receive_enable)
            bit_count <= bit_count + 3'd1;
        else
            bit_count <= 3'd0;
    end

    // Sequential: data_shift shifts in LSB-first serial bit on RECEIVE enable by right-shifting and inserting 'in' as MSB
    // To simplify logic and improve timing, shift right and place new bit into MSB, then at output reverse bit order if needed,
    // but the problem expects least significant bit first, so to store correctly, we shift right and put new bit at MSB.
    // Alternatively, shift left and put new bit in LSB, which is logically simpler and reduces critical path.
    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (receive_enable)
            data_shift <= {in, data_shift[7:1]}; // shift right, new bit at MSB; matches LSB-first serial input
        else if (state == IDLE && in == 1'b0)
            data_shift <= 8'd0; // clear data at start bit detection
    end

    // Sequential: output and done signal logic, done pulses 1 cycle after valid stop bit detected
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default done low
            if (state == CHECK_STOP && in == 1'b1) begin
                out_byte <= data_shift;
                done <= 1'b1;
            end
        end
    end

    // Combinational: next state logic for FSM
    always @(*) begin
        next_state = IDLE; // default safe state

        case (state)
            IDLE: begin
                if (in == 1'b0)         // start bit detected (line went low)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7) // all 8 bits received
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end

            CHECK_STOP: begin
                if (in == 1'b1)        // valid stop bit
                    next_state = IDLE;
                else
                    next_state = RECOVER; // invalid stop bit, wait for line idle
            end

            RECOVER: begin
                if (in == 1'b1)        // wait until line idle (stop bit=1)
                    next_state = IDLE;
                else
                    next_state = RECOVER;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule