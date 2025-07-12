module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding (binary)
    localparam IDLE      = 2'b00;
    localparam RECEIVE   = 2'b01;
    localparam STOP      = 2'b10;
    localparam WAIT_STOP = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_shift;

    wire receive_enable = (state == RECEIVE);

    // Sequential state update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter with synchronous reset and increment when receiving
    always @(posedge clk) begin
        if (reset)
            bit_count <= 3'd0;
        else if (receive_enable)
            bit_count <= bit_count + 3'd1;
        else if (state == IDLE && in == 1'b0)
            bit_count <= 3'd0;  // reset on start bit detection
    end

    // Shift register shifts in LSB first when receiving data bits
    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (state == IDLE && in == 1'b0)
            data_shift <= 8'd0;
        else if (receive_enable)
            data_shift <= {in, data_shift[7:1]};
    end

    // Output and done signal logic: done asserted for one cycle in STOP when valid stop bit found
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default done low each cycle
            if (state == STOP && in == 1'b1) begin
                out_byte <= data_shift;
                done <= 1'b1;
            end
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = IDLE; // default safe state

        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;  // start bit detected
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP;     // after 8 data bits received
                else
                    next_state = RECEIVE;
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;     // valid stop bit: ready for next byte
                else
                    next_state = WAIT_STOP;// invalid stop bit: wait for idle
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;     // line idle regained, restart
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule