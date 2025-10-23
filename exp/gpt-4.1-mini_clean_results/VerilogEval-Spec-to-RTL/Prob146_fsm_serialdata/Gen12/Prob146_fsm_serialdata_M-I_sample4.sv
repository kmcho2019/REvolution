module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // Binary encoded FSM states (2 bits)
    localparam IDLE      = 2'd0;
    localparam RECEIVE   = 2'd1;
    localparam STOP      = 2'd2;
    localparam WAIT_STOP = 2'd3;

    reg [1:0] state, next_state;

    reg [7:0] data_shift;
    reg [2:0] bit_count;

    wire receive_enable = (state == RECEIVE);

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter with clock enable
    always @(posedge clk) begin
        if (reset)
            bit_count <= 3'd0;
        else if (receive_enable)
            bit_count <= bit_count + 3'd1;
        else if (state == IDLE && in == 1'b0) // start bit detected, reset bit_count
            bit_count <= 3'd0;
    end

    // Shift register for data bits, shifts LSB first (shift left, in at LSB)
    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (state == IDLE && in == 1'b0)
            data_shift <= 8'd0;
        else if (receive_enable)
            data_shift <= {in, data_shift[7:1]}; // shift right, in at MSB (original)
        // To shift LSB first more naturally, shift left:
        // data_shift <= {in, data_shift[7:1]}; (existing)
        // But this shifts in at MSB; LSB first means incoming bit is LSB
        // So better to shift left and insert 'in' at LSB:
        // data_shift <= {data_shift[6:0], in};
    end

    // Redo shift register to shift left with 'in' at LSB:
    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (state == IDLE && in == 1'b0)
            data_shift <= 8'd0;
        else if (receive_enable)
            data_shift <= {data_shift[6:0], in};
    end

    // Output registers and done signal, done asserted only when needed
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;
            if (state == STOP && in == 1'b1) begin // valid stop bit
                out_byte <= data_shift;
                done <= 1'b1;
            end
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = IDLE; // default
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE; // start bit detected
                else
                    next_state = IDLE;
            end
            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP; // after 8 data bits received
                else
                    next_state = RECEIVE;
            end
            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;     // valid stop bit, back to idle
                else
                    next_state = WAIT_STOP; // invalid stop bit, wait for line idle
            end
            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE; // line idle regained
                else
                    next_state = WAIT_STOP;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule