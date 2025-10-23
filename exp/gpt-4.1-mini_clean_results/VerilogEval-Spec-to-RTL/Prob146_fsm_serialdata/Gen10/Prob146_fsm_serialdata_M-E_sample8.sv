module TopModule (
    input        clk,
    input        in,
    input        reset,
    output reg [7:0] out_byte,
    output reg       done
);

    // State encoding (one-hot for clarity and slightly faster decoding)
    localparam IDLE       = 5'b00001;
    localparam START_WAIT = 5'b00010;
    localparam RECEIVE    = 5'b00100;
    localparam STOP_CHECK = 5'b01000;
    localparam RECOVER    = 5'b10000;

    reg [4:0] state, next_state;

    reg [7:0] data_reg;
    reg [2:0] bit_cnt;  // count from 0 to 7 for data bits

    // FSM next state combinational logic
    always @(*) begin
        next_state = state; // default hold
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = START_WAIT;
            end

            START_WAIT: begin
                // Confirm start bit still low (debounce)
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_cnt == 3'd7)
                    next_state = STOP_CHECK;
                else
                    next_state = RECEIVE;
            end

            STOP_CHECK: begin
                if (in == 1'b1)
                    next_state = IDLE;      // good stop bit, ready for next byte
                else
                    next_state = RECOVER;   // bad stop bit, wait for idle line
            end

            RECOVER: begin
                if (in == 1'b1)
                    next_state = IDLE;      // recovered
                else
                    next_state = RECOVER;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential state update
    always @(posedge clk) begin
        if (reset) 
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit count and data shift management
    always @(posedge clk) begin
        if (reset) begin
            bit_cnt <= 3'd0;
            data_reg <= 8'd0;
        end else begin
            case (state)
                IDLE: begin
                    bit_cnt <= 3'd0;
                    data_reg <= 8'd0;
                end

                START_WAIT: begin
                    bit_cnt <= 3'd0;
                    data_reg <= 8'd0;
                end

                RECEIVE: begin
                    // shift in LSB first at each bit position
                    // shift data right and insert new bit in MSB side to build byte reversed,
                    // but since serial sends LSB first, shift left and insert new bit at LSB instead
                    data_reg <= {in, data_reg[7:1]};
                    bit_cnt <= bit_cnt + 3'd1;
                end

                STOP_CHECK, RECOVER: begin
                    // no change to bit_cnt or data_reg
                end
            endcase
        end
    end

    // Output logic with done pulse generation
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default no pulse

            if (state == STOP_CHECK && in == 1'b1) begin
                // stop bit valid, latch output and pulse done
                out_byte <= data_reg;
                done <= 1'b1;
            end
        end
    end

endmodule