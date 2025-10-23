module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire done
);

    // State encoding using localparam
    localparam IDLE       = 2'b00;
    localparam RECEIVE    = 2'b01;
    localparam CHECK_STOP = 2'b10;
    localparam WAIT_STOP  = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;      // Counts bits received (0..7)
    reg [7:0] shift_reg;      // Holds received data bits
    reg done_reg;             // Registered done pulse

    // Combinational logic for next_state
    always @(*) begin
        next_state = state;   // default hold state

        case (state)
            IDLE: begin
                if (in == 1'b0)          // Start bit detected
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end

            CHECK_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;  // Correct stop bit
                else
                    next_state = WAIT_STOP; // Wait for stop bit if invalid
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

    // Sequential logic: update state, counters, shift_reg and done pulse
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done_reg  <= 1'b0;
        end else begin
            state <= next_state;

            // Default done deassert
            done_reg <= 1'b0;

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift in bits LSB-first: shift left, insert in at bit 0
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1;
                end

                CHECK_STOP: begin
                    // If stop bit correct, pulse done
                    if (in == 1'b1)
                        done_reg <= 1'b1;

                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                WAIT_STOP: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                default: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

    // Done output is the registered done pulse
    assign done = done_reg;

endmodule