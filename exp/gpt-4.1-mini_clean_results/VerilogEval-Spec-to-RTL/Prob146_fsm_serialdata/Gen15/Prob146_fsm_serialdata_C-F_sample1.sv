module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // FSM state encoding (2-bit binary)
    localparam IDLE      = 2'b00;
    localparam RECEIVE   = 2'b01;
    localparam STOP      = 2'b10;
    localparam WAIT_STOP = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_shift;

    // Enable signals for counters and shift register updates
    wire enable_receive = (state == RECEIVE);

    // Sequential logic: state transition
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter: increment only in RECEIVE, reset on reset or start bit detection
    always @(posedge clk) begin
        if (reset)
            bit_count <= 3'd0;
        else if (enable_receive)
            bit_count <= bit_count + 3'd1;
        else if (state == IDLE && in == 1'b0)
            bit_count <= 3'd0;
        // else hold current bit_count to avoid glitches
    end

    // Shift register: reset on start bit, shift in new bits only in RECEIVE
    // Serial protocol LSB first: shift right, new bit enters MSB
    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (state == IDLE && in == 1'b0)
            data_shift <= 8'd0;
        else if (enable_receive)
            data_shift <= {in, data_shift[7:1]};
        // else hold data_shift steady
    end

    // Output register and done pulse generation: done asserted one cycle when valid stop bit detected
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            done <= 1'b0; // default done low

            if (state == STOP && in == 1'b1) begin
                done <= 1'b1;
                out_byte <= data_shift;
            end
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;     // Start bit detected
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP;        // All 8 data bits received
                else
                    next_state = RECEIVE;
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;        // Valid stop bit: ready for next byte
                else
                    next_state = WAIT_STOP;   // Invalid stop bit: wait until line idle
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;        // Line idle regained
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule