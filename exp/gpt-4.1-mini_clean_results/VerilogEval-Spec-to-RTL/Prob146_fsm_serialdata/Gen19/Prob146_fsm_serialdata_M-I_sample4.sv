module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // Binary encoded states
    localparam IDLE       = 2'b00;
    localparam RECEIVE    = 2'b01;
    localparam STOP       = 2'b10;
    localparam ERROR_WAIT = 2'b11;

    reg [1:0] state, next_state;

    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    // Synchronize input 'in' to avoid glitches in combinational logic
    reg in_sync;
    always @(posedge clk) begin
        if (reset)
            in_sync <= 1'b1; // line idle state
        else
            in_sync <= in;
    end

    // FSM state register
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter: count bits only in RECEIVE state, reset otherwise
    always @(posedge clk) begin
        if (reset)
            bit_cnt <= 3'd0;
        else if (state == RECEIVE)
            bit_cnt <= bit_cnt + 3'd1;
        else
            bit_cnt <= 3'd0;
    end

    // Shift register: shift right, insert serial input bit at MSB (since LSB-first)
    // Shift and count enabled only in RECEIVE state
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 8'd0;
        else if (state == RECEIVE)
            shift_reg <= {in_sync, shift_reg[7:1]};
        else
            shift_reg <= shift_reg; // hold value to reduce toggling
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                // Wait for start bit (0)
                if (in_sync == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end
            RECEIVE: begin
                // After 8 bits received, go to STOP state
                if (bit_cnt == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end
            STOP: begin
                // Check if stop bit is 1
                if (in_sync == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end
            ERROR_WAIT: begin
                // Wait until stop bit detected (in_sync==1)
                if (in_sync == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic: done asserted for one clock cycle when valid stop bit received
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            done <= 1'b0;
            if (state == STOP && in_sync == 1'b1) begin
                done <= 1'b1;
                out_byte <= shift_reg;
            end
        end
    end

endmodule