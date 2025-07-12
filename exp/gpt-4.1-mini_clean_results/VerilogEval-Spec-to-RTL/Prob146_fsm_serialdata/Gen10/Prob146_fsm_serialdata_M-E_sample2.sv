module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // One-hot state encoding
    localparam IDLE       = 4'b0001;
    localparam RECEIVE    = 4'b0010;
    localparam STOP       = 4'b0100;
    localparam ERROR_WAIT = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_cnt;       // counts 0 to 7
    reg [7:0] shift_reg;

    wire receive_en = (state == RECEIVE);

    // FSM state register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter, increments only in RECEIVE state
    always @(posedge clk) begin
        if (reset)
            bit_cnt <= 3'd0;
        else if (receive_en)
            bit_cnt <= bit_cnt + 3'd1;
        else if (state == IDLE)
            bit_cnt <= 3'd0;
    end

    // Shift register loading LSB first, shifts in new bit at LSB
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 8'd0;
        else if (state == IDLE)
            shift_reg <= 8'd0;
        else if (receive_en)
            shift_reg <= {in, shift_reg[7:1]};
    end

    // done and out_byte registers, done asserted one cycle on valid stop bit
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            done <= 1'b0; // default done low
            if (state == STOP && in == 1'b1) begin
                done <= 1'b1;
                out_byte <= shift_reg;
            end
        end
    end

    // Next state logic (Moore FSM)
    always @(*) begin
        case (state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                // After receiving 8 bits (bit_cnt = 7), go to STOP
                if (bit_cnt == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;       // Valid stop bit, byte done
                else
                    next_state = ERROR_WAIT; // Invalid stop bit, wait for idle
            end

            ERROR_WAIT: begin
                if (in == 1'b1)
                    next_state = IDLE;       // Return to IDLE when line idle
                else
                    next_state = ERROR_WAIT;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule