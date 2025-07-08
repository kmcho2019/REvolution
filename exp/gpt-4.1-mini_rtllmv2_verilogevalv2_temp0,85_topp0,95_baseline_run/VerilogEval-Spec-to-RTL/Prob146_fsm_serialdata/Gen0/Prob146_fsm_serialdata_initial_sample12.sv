module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg [7:0]  out_byte,
    output reg        done
);

    // FSM states
    localparam IDLE      = 3'd0;
    localparam START     = 3'd1;
    localparam DATA      = 3'd2;
    localparam STOP      = 3'd3;
    localparam WAIT_STOP = 3'd4;

    reg [2:0] state, next_state;
    reg [3:0] bit_count;    // counts 0 to 7 for data bits
    reg [7:0] data_shift;   // shift register for data bits

    // Sequential logic for state, bit_count, data_shift, done and output
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data_shift <= 8'b0;
            done <= 1'b0;
            out_byte <= 8'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default no done pulse

            case (state)
                IDLE: begin
                    bit_count <= 0;
                    data_shift <= 8'b0;
                end
                START: begin
                    // nothing to update here besides state
                end
                DATA: begin
                    // shift in data bits LSB first
                    // data_shift shifts in new bit at MSB end to keep LSB first easily
                    // Actually, since LSB first, we shift in at bit position bit_count
                    data_shift[bit_count] <= in;
                end
                STOP: begin
                    // If stop bit correct, output done and latch data
                    if (in == 1'b1) begin
                        out_byte <= data_shift;
                        done <= 1'b1;
                    end
                end
                WAIT_STOP: begin
                    // waiting for line to go back to 1
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0) // start bit detected
                    next_state = START;
            end
            START: begin
                // Confirm start bit still zero, else back to IDLE
                if (in == 1'b0)
                    next_state = DATA;
                else
                    next_state = IDLE; // false start bit
            end
            DATA: begin
                if (bit_count == 7)
                    next_state = STOP;
                else
                    next_state = DATA;
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
                else
                    next_state = WAIT_STOP;
            end
            default: next_state = IDLE;
        endcase
    end

    // Bit count update logic (only in DATA state)
    always @(posedge clk) begin
        if (reset) begin
            bit_count <= 0;
        end else begin
            if (state == DATA)
                bit_count <= bit_count + 1;
            else
                bit_count <= 0;
        end
    end

endmodule