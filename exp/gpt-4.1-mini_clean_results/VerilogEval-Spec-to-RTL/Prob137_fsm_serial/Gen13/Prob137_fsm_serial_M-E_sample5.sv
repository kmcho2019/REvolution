module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // States definition
    localparam IDLE          = 3'd0;
    localparam START_DETECTED= 3'd1;
    localparam RECEIVE_BITS  = 3'd2;
    localparam STOP_BIT      = 3'd3;
    localparam RESYNC        = 3'd4;

    reg [2:0] state, next_state;
    reg [3:0] bit_counter; // Counts from 0 to 7 for data bits

    // Sequential logic: state transitions and counters
    always @(posedge clk) begin
        if (reset) begin
            state       <= IDLE;
            bit_counter <= 4'd0;
            done        <= 1'b0;
        end else begin
            state <= next_state;

            // Default done deassert
            done <= 1'b0;

            case (state)
                IDLE: begin
                    bit_counter <= 4'd0;
                    // Wait for start bit 0
                end

                START_DETECTED: begin
                    bit_counter <= 4'd0;
                    // Move immediately to RECEIVE_BITS next cycle
                end

                RECEIVE_BITS: begin
                    bit_counter <= bit_counter + 1'b1;
                    // Accumulate received bits count
                end

                STOP_BIT: begin
                    // If valid stop bit, pulse done; else go to RESYNC
                    if (in == 1'b1) begin
                        done <= 1'b1;
                        bit_counter <= 4'd0;
                    end
                end

                RESYNC: begin
                    // Wait until line is high again to resync
                    bit_counter <= 4'd0;
                end
            endcase
        end
    end

    // Combinational next_state logic
    always @(*) begin
        next_state = state; // default

        case (state)
            IDLE: begin
                // Line idle is high; detect start bit low
                if (in == 1'b0)
                    next_state = START_DETECTED;
                else
                    next_state = IDLE;
            end

            START_DETECTED: begin
                // After detecting start bit, immediately start receiving bits
                next_state = RECEIVE_BITS;
            end

            RECEIVE_BITS: begin
                if (bit_counter == 4'd7)
                    next_state = STOP_BIT;
                else
                    next_state = RECEIVE_BITS;
            end

            STOP_BIT: begin
                if (in == 1'b1)
                    next_state = IDLE; // Correct stop bit, go to IDLE
                else
                    next_state = RESYNC; // Bad stop bit, resync needed
            end

            RESYNC: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = RESYNC;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule