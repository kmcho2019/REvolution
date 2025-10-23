module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding as localparams (2-bit binary)
    localparam IDLE       = 2'b00;
    localparam RECEIVE    = 2'b01;
    localparam STOP       = 2'b10;
    localparam WAIT_STOP  = 2'b11;

    reg [1:0] state, next_state;

    reg [7:0] data_shift;
    reg [2:0] bit_count;

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: 
                if (in == 1'b0)  // start bit detected
                    next_state = RECEIVE;
                else
                    next_state = IDLE;

            RECEIVE: 
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;

            STOP: 
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;

            WAIT_STOP:
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;

            default: next_state = IDLE;
        endcase
    end

    // Sequential block for state, data_shift, bit_count, done, and out_byte
    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            data_shift <= 8'd0;
            bit_count  <= 3'd0;
            done       <= 1'b0;
            out_byte   <= 8'd0;
        end else begin
            state <= next_state;
            done  <= 1'b0; // default no done pulse

            case (state)
                IDLE: begin
                    // Wait for start bit, no shifting here
                    // Clear data_shift and bit_count only when start bit detected (for clarity)
                    if (in == 1'b0) begin
                        data_shift <= 8'd0;
                        bit_count  <= 3'd0;
                    end
                end

                RECEIVE: begin
                    // Shift in LSB-first data: incoming bit goes to LSB, shift left
                    data_shift <= {in, data_shift[7:1]};
                    bit_count  <= bit_count + 3'd1;
                end

                STOP: begin
                    // On valid stop bit, output done and byte
                    if (in == 1'b1) begin
                        out_byte <= data_shift;
                        done <= 1'b1;
                    end
                    // else wait for stop bit in WAIT_STOP state
                end

                WAIT_STOP: begin
                    // Do nothing until line returns to idle (stop bit=1)
                end

                default: begin
                    // Default catch all
                end
            endcase
        end
    end

endmodule