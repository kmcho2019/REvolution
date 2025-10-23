module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg [7:0]  out_byte,
    output reg        done
);

    // One-hot state encoding for 4 states
    localparam IDLE      = 4'b0001;
    localparam RECEIVE   = 4'b0010;
    localparam STOP      = 4'b0100;
    localparam WAIT_STOP = 4'b1000;

    reg [3:0] state, next_state;

    reg [2:0] bit_count;
    reg [7:0] data_shift;

    // Next state combinational logic (Moore FSM)
    always @(*) begin
        // Default next_state
        next_state = state;

        case (state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = RECEIVE;
            end

            RECEIVE: begin
                // After receiving 8 data bits go to STOP state
                if (bit_count == 3'd7)
                    next_state = STOP;
            end

            STOP: begin
                // If stop bit is 1, go back to IDLE (byte done)
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    // Framing error - wait for line to go back to idle (stop bit)
                    next_state = WAIT_STOP;
            end

            WAIT_STOP: begin
                // Wait for stop bit = 1 to return to IDLE
                if (in == 1'b1)
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // State register update
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter update
    always @(posedge clk) begin
        if (reset)
            bit_count <= 3'd0;
        else if (state == IDLE && next_state == RECEIVE)
            bit_count <= 3'd0;
        else if (state == RECEIVE)
            bit_count <= bit_count + 1'b1;
        else
            bit_count <= bit_count;
    end

    // Shift register update, LSB first means incoming bit at MSB when right shifting
    always @(posedge clk) begin
        if (reset)
            data_shift <= 8'd0;
        else if (state == IDLE && next_state == RECEIVE)
            data_shift <= 8'd0;
        else if (state == RECEIVE)
            data_shift <= {in, data_shift[7:1]};
        else
            data_shift <= data_shift;
    end

    // Output logic and done signal
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;
            if (state == STOP && in == 1'b1) begin
                out_byte <= data_shift;
                done <= 1'b1;
            end
        end
    end

endmodule