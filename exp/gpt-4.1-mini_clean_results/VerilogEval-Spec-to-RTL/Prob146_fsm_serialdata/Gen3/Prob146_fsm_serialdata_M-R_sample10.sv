module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State definitions - one-hot style encoding for clarity
    localparam IDLE       = 4'b0001;
    localparam RECEIVE    = 4'b0010;
    localparam STOP       = 4'b0100;
    localparam WAIT_STOP  = 4'b1000;

    reg [3:0] state, next_state;

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

    // Bit counter with synchronous reset on start bit detection
    always @(posedge clk) begin
        if (reset)
            bit_count <= 3'd0;
        else if (receive_enable)
            bit_count <= bit_count + 3'd1;
        else if (state == IDLE && in == 1'b0) // detect start bit
            bit_count <= 3'd0;
    end

    // Shift register for data bits, shifts in LSB first on receive_enable
    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (state == IDLE && in == 1'b0)
            data_shift <= 8'd0;
        else if (receive_enable)
            data_shift <= {in, data_shift[7:1]};
    end

    // Output registers and done signal
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default done low
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
                    next_state = STOP; // after 8 bits received
                else
                    next_state = RECEIVE;
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
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule