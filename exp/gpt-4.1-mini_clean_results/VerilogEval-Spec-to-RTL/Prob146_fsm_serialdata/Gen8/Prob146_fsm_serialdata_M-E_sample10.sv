module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // States encoded as 2-bit binary:
    localparam IDLE       = 2'd0;
    localparam RECEIVE    = 2'd1;
    localparam STOP_CHECK = 2'd2;
    localparam WAIT_STOP  = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;      // counts 0 to 7 data bits received
    reg [7:0] shift_reg;      // holds incoming data bits

    // State register
    always @(posedge clk) begin
        if (reset) 
            state <= IDLE;
        else 
            state <= next_state;
    end

    // Bit counter
    always @(posedge clk) begin
        if (reset)
            bit_count <= 3'd0;
        else if (state == IDLE)
            bit_count <= 3'd0;
        else if (state == RECEIVE)
            bit_count <= bit_count + 3'd1;
        else if (state == STOP_CHECK || state == WAIT_STOP)
            bit_count <= 3'd0;
    end

    // Shift register: shift right, insert new bit at MSB to receive LSB first
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 8'b0;
        else if (state == RECEIVE)
            shift_reg <= {in, shift_reg[7:1]};
        else if (state == IDLE)
            shift_reg <= 8'b0;
    end

    // done and output register
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'b0;
        end else if (state == STOP_CHECK && in == 1'b1) begin
            // Valid stop bit
            done <= 1'b1;
            out_byte <= shift_reg;
        end else begin
            done <= 1'b0;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;  // default hold

        case (state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = RECEIVE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP_CHECK;
            end

            STOP_CHECK: begin
                if (in == 1'b1)
                    next_state = IDLE;         // Stop bit valid, ready for next byte
                else
                    next_state = WAIT_STOP;    // Stop bit invalid, wait for idle line
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;         // Line idle regained, restart detection
            end
        endcase
    end

endmodule