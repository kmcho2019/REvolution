module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // One-hot state encoding
    localparam IDLE       = 4'b0001;
    localparam RECEIVE    = 4'b0010;
    localparam CHECK_STOP = 4'b0100;
    localparam WAIT_STOP  = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Next-state logic combinational
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)      // Start bit detected
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
                    next_state = IDLE;     // Valid stop bit, ready for next byte
                else
                    next_state = WAIT_STOP; // Framing error: wait for stop bit
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;     // Stop bit found, recover to IDLE
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0; // Default done low

            case (next_state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Update bit_count and shift_reg only during RECEIVE
                    bit_count <= bit_count + 1;
                    // Shift right with new bit in MSB to keep LSB-first order
                    shift_reg <= {in, shift_reg[7:1]};
                end

                CHECK_STOP: begin
                    bit_count <= 3'd0;
                    // No need to clear shift_reg here to reduce toggling
                    if (in == 1'b1)
                        done <= 1'b1;
                end

                WAIT_STOP: begin
                    bit_count <= 3'd0;
                    // Hold shift_reg value, no updates to reduce toggling
                end

                default: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule