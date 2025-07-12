module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    typedef enum reg [1:0] {
        IDLE       = 2'b00,
        RECEIVE    = 2'b01,
        STOP_CHECK = 2'b10,
        RECOVER    = 2'b11
    } state_t;

    state_t state, next_state;

    reg [7:0] shift_reg;
    reg [2:0] bit_count;
    reg done_reg;

    // State transition
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter increments only in RECEIVE
    always @(posedge clk) begin
        if (reset)
            bit_count <= 3'd0;
        else if (state == RECEIVE)
            bit_count <= bit_count + 3'd1;
        else
            bit_count <= 3'd0;
    end

    // Shift register load during RECEIVE state
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 8'd0;
        else if (state == RECEIVE)
            shift_reg <= {in, shift_reg[7:1]}; // shift right to capture LSB first
        else if (state == IDLE)
            shift_reg <= 8'd0;
    end

    // Done flag pulses one cycle when stop bit validated
    always @(posedge clk) begin
        if (reset)
            done_reg <= 1'b0;
        else if (state == STOP_CHECK && in == 1'b1)
            done_reg <= 1'b1;
        else
            done_reg <= 1'b0;
    end

    // Output registers
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= done_reg;
            if (done_reg)
                out_byte <= shift_reg;
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0) // start bit detected
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
                    next_state = IDLE;
                else
                    next_state = RECOVER;
            end
            RECOVER: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = RECOVER;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule