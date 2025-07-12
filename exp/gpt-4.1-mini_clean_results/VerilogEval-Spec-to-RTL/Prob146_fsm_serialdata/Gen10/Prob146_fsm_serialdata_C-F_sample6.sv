module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // FSM states encoded as 2-bit binary:
    localparam IDLE       = 2'b00;
    localparam RECEIVE    = 2'b01;
    localparam STOP_CHECK = 2'b10;
    localparam WAIT_STOP  = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Control signal: active only during data reception
    wire receive_enable = (state == RECEIVE);

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter updates only when receiving data bits
    always @(posedge clk) begin
        if (reset)
            bit_count <= 3'd0;
        else if (state == IDLE && in == 1'b0)
            bit_count <= 3'd0;  // reset counter on start bit detection
        else if (receive_enable)
            bit_count <= bit_count + 3'd1;
    end

    // Shift register shifts in serial data bits LSB first by right-shifting and inserting at MSB
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 8'd0;
        else if (state == IDLE && in == 1'b0)
            shift_reg <= 8'd0;  // clear on start bit detection
        else if (receive_enable)
            shift_reg <= {in, shift_reg[7:1]};
    end

    // Output registers and done signal, done asserted one cycle on valid stop bit
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            done <= 1'b0;  // default low
            if (state == STOP_CHECK && in == 1'b1) begin
                done <= 1'b1;
                out_byte <= shift_reg;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            IDLE: begin
                if (in == 1'b0)       // start bit detected
                    next_state = RECEIVE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP_CHECK;
            end

            STOP_CHECK: begin
                if (in == 1'b1)
                    next_state = IDLE;       // valid stop bit, ready for next byte
                else
                    next_state = WAIT_STOP;  // invalid stop bit, wait for line idle
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;       // line idle regained
            end

            default: next_state = IDLE;
        endcase
    end

endmodule