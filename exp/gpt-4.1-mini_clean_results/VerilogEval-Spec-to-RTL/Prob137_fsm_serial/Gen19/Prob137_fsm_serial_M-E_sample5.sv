module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // States for clarity
    localparam IDLE       = 2'b00;
    localparam RECEIVE    = 2'b01;
    localparam STOP_CHECK = 2'b10;
    localparam RECOVER    = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Next state combinational logic
    always @(*) begin
        case(state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP_CHECK;
                else
                    next_state = RECEIVE;
            end

            STOP_CHECK: begin
                if (in == 1'b1)
                    next_state = IDLE;     // Valid stop bit, go back to idle
                else
                    next_state = RECOVER;  // Framing error, wait for line to go high
            end

            RECOVER: begin
                if (in == 1'b1)
                    next_state = IDLE;     // Stop bit detected, can restart receiving
                else
                    next_state = RECOVER;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state, bit_count, shift_reg, done
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // Default done to 0 on each clock cycle
            done <= 1'b0;

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift in data bits LSB first: incoming bit goes to bit 0, existing bits shift left
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end

                STOP_CHECK: begin
                    // If stop bit correct, pulse done high for one cycle
                    if (in == 1'b1) begin
                        done <= 1'b1;
                    end
                    // bit_count and shift_reg cleared on next cycle at IDLE
                end

                RECOVER: begin
                    // Hold bit_count and shift_reg; wait for valid stop bit to return to IDLE
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

endmodule