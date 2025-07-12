module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding for clarity and minimal registers
    localparam IDLE       = 2'd0;
    localparam RECEIVE    = 2'd1;
    localparam CHECK_STOP = 2'd2;
    localparam WAIT_STOP  = 2'd3;

    reg [1:0] state, next_state;
    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    // Next state logic combinational block
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;      // Start bit detected
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
                    next_state = IDLE;         // Valid stop bit
                else
                    next_state = WAIT_STOP;    // Framing error, wait for stop bit
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;         // Stop bit detected, recover
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential block: state transition, registers update, done pulse generation
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            shift_reg <= 8'd0;
            bit_count <= 3'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // Default done low each cycle; pulse high on correct stop bit only
            done <= 1'b0;

            case (state)
                IDLE: begin
                    // Hold registers steady in IDLE to reduce toggling
                    shift_reg <= shift_reg;
                    bit_count <= bit_count;
                end

                RECEIVE: begin
                    // Shift right and load new bit into MSB (LSB first serial input)
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end

                CHECK_STOP: begin
                    // Hold shift_reg and bit_count steady
                    shift_reg <= shift_reg;
                    bit_count <= 3'd0;

                    if (in == 1'b1)
                        done <= 1'b1;            // Pulse done on correct stop bit
                end

                WAIT_STOP: begin
                    // Hold registers steady during wait for stop bit to reduce toggling
                    shift_reg <= shift_reg;
                    bit_count <= 3'd0;
                end

                default: begin
                    shift_reg <= 8'd0;
                    bit_count <= 3'd0;
                end
            endcase
        end
    end

endmodule