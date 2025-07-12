module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE,      // Waiting for start bit (0)
        RECEIVE,    // Receiving 8 data bits
        STOP        // Checking stop bit (1)
    } state_t;

    reg [1:0] state, next_state;
    reg [7:0] data_shift;
    reg [2:0] bit_count;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            data_shift <= 8'b0;
            bit_count <= 3'b0;
        end else begin
            state <= next_state;
            
            case (state)
                RECEIVE: begin
                    data_shift <= {in, data_shift[7:1]};  // LSB first
                    bit_count <= bit_count + 1;
                end
                default: begin
                    bit_count <= 3'b0;
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            IDLE:    next_state = (~in) ? RECEIVE : IDLE;
            RECEIVE: next_state = (bit_count == 3'd7) ? STOP : RECEIVE;
            STOP:    next_state = IDLE;  // Always return to IDLE after STOP
            default: next_state = IDLE;
        endcase
    end

    // Done signal - pulse when valid stop bit is detected
    assign done = (state == STOP) & in;

endmodule