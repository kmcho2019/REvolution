module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding
    localparam IDLE       = 2'b00;
    localparam RECEIVING  = 2'b01;
    localparam ERROR_WAIT = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] bit_cnt;      // counts from 0 to 7 for 8 bits
    reg [7:0] shift_reg;    // holds received bits

    // FSM state register
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter register
    always @(posedge clk) begin
        if (reset)
            bit_cnt <= 3'd0;
        else if (state == RECEIVING)
            bit_cnt <= bit_cnt + 3'd1;
        else
            bit_cnt <= 3'd0;
    end

    // Shift register: shift right, new bit into MSB
    // Shift only during RECEIVING state
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 8'b0;
        else if (state == RECEIVING)
            shift_reg <= {in, shift_reg[7:1]};
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (in == 1'b0) // start bit detected
                    next_state = RECEIVING;
                else
                    next_state = IDLE;
            end
            RECEIVING: begin
                if (bit_cnt == 3'd7)
                    next_state = (in == 1'b1) ? IDLE : ERROR_WAIT; // checking stop bit next cycle
                else
                    next_state = RECEIVING;
            end
            ERROR_WAIT: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic and done signal
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;
            if (state == RECEIVING && bit_cnt == 3'd7) begin
                // Next clock cycle will be stop bit check, so hold done for one cycle here
                // done will assert in IDLE after verifying stop bit
            end

            if (state == RECEIVING && bit_cnt == 3'd7 && next_state == IDLE) begin
                // Valid stop bit detected, output received byte and assert done
                out_byte <= shift_reg;
                done <= 1'b1;
            end
        end
    end

endmodule