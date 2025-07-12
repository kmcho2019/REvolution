module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states
    typedef enum reg [2:0] {
        IDLE  = 3'd0,
        START = 3'd1,
        DATA  = 3'd2,
        STOP  = 3'd3,
        ERROR = 3'd4
    } state_t;

    state_t state, next_state;
    reg [2:0] bit_count;    // to count bits received (0 to 7)
    reg [7:0] shift_reg;    // to shift in data bits

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // done asserted only one cycle when a byte received correctly

            case (state)
                IDLE: begin
                    // Wait for start bit (0)
                    bit_count <= 3'd0;
                end
                START: begin
                    // Start bit detected (in==0), prepare to receive data bits
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
                DATA: begin
                    // Shift in the data bits LSB first
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1;
                end
                STOP: begin
                    // After receiving 8 bits, check stop bit
                    if (in == 1'b1) begin
                        // Valid stop bit
                        out_byte <= shift_reg;
                        done <= 1'b1;
                    end
                end
                ERROR: begin
                    // Waiting for stop bit (in==1) before going back to IDLE
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = START;
            end
            START: begin
                // Confirm start bit still 0, move to DATA to receive 8 bits
                // If line not 0, return to IDLE
                if (in == 1'b0)
                    next_state = DATA;
                else
                    next_state = IDLE;
            end
            DATA: begin
                if (bit_count == 3'd7)
                    next_state = STOP;
            end
            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE; // correctly received byte
                else
                    next_state = ERROR; // bad stop bit
            end
            ERROR: begin
                if (in == 1'b1)
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule