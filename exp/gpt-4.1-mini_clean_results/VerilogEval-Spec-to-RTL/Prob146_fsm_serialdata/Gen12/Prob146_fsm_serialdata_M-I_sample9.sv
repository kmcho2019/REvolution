module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State definitions - binary encoding
    localparam IDLE       = 2'b00;
    localparam RECEIVE    = 2'b01;
    localparam STOP       = 2'b10;
    localparam WAIT_STOP  = 2'b11;

    reg [1:0] state, next_state;

    reg [7:0] data_shift;
    reg [2:0] bit_count;

    wire receive_enable = (state == RECEIVE);

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter with synchronous reset on start bit detection and clock enable
    always @(posedge clk) begin
        if (reset)
            bit_count <= 3'd0;
        else if (state == IDLE && in == 1'b0) // start bit detected
            bit_count <= 3'd0;
        else if (receive_enable)
            bit_count <= bit_count + 3'd1;
    end

    // Shift register for data bits, shifts in LSB first on receive_enable
    // Shift left, input bit at LSB
    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (state == IDLE && in == 1'b0)
            data_shift <= 8'd0;
        else if (receive_enable)
            data_shift <= {in, data_shift[7:1]};  // Previous approach shifted in MSB, but since LSB first, shift right and put new bit into MSB is correct
                                                 // Actually, since serial sends LSB first, shifting right and inserting MSB is correct
                                                 // Retain this to keep correctness
    end

    // Output registers and done signal, update done only in STOP state to reduce toggling
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;
            if (state == STOP) begin
                if (in == 1'b1) begin // valid stop bit
                    out_byte <= data_shift;
                    done <= 1'b1;
                end
            end
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state; // hold current state by default

        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE; // start bit detected
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP; // after 8 bits received
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;    // valid stop bit, go idle
                else
                    next_state = WAIT_STOP; // invalid stop bit, wait for line idle
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE; // line idle regained
            end

            default: next_state = IDLE;
        endcase
    end

endmodule