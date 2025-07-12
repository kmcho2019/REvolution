module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // FSM states encoded in 2 bits
    localparam IDLE       = 2'd0;
    localparam RECEIVE    = 2'd1;
    localparam CHECK_STOP = 2'd2;
    localparam WAIT_STOP  = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Next state combinational logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (in == 1'b0)         // Start bit detected (line goes low)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)  // After 8 bits received
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end

            CHECK_STOP: begin
                if (in == 1'b1)         // Valid stop bit
                    next_state = IDLE;
                else                    // Framing error, wait for stop bit
                    next_state = WAIT_STOP;
            end

            WAIT_STOP: begin
                if (in == 1'b1)         // Wait for line idle (stop bit)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state, counter, shift register, done signal
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // Default done deasserted each cycle; pulse only on valid stop bit
            done <= 1'b0;

            case(state)
                IDLE: begin
                    // Clear counters and shift register only in IDLE to minimize toggling
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift left by 1, insert new bit at LSB (LSB first)
                    // This places first received bit in shift_reg[0] correctly as per protocol
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end

                CHECK_STOP: begin
                    // Assert done for one cycle only if stop bit correct
                    if (in == 1'b1)
                        done <= 1'b1;
                    // Reset bit_count here for next byte after stop bit checking
                    bit_count <= 3'd0;
                end

                WAIT_STOP: begin
                    // Wait for line idle, clear counters and shift_reg to prepare for next frame
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

endmodule