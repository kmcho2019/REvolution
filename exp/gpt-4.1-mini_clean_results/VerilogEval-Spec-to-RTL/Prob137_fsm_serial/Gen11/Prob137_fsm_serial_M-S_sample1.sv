module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // One-hot state encoding
    localparam IDLE      = 3'b001;
    localparam RECEIVING = 3'b010;
    localparam ERROR     = 3'b100;

    reg [2:0] state, next_state;
    reg [3:0] bit_count;  // 4 bits to count 0 to 8

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 0;
            done      <= 0;
        end else begin
            state <= next_state;
            done  <= 1'b0; // default no pulse

            case (state)
                IDLE: begin
                    bit_count <= 0;
                end
                RECEIVING: begin
                    bit_count <= bit_count + 1;
                end
                ERROR: begin
                    bit_count <= 0;
                end
            endcase

            // Assert done when in RECEIVING state and bit_count is 8 (stop bit)
            if (state == RECEIVING && bit_count == 4'd8) begin
                // bit_count == 8 corresponds to stop bit
                if (in == 1'b1)
                    done <= 1'b1;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;

        case (state)
            IDLE: begin
                if (in == 1'b0) // start bit detected
                    next_state = RECEIVING;
                else
                    next_state = IDLE;
            end

            RECEIVING: begin
                if (bit_count < 4'd8)
                    next_state = RECEIVING; // receiving data bits + stop bit
                else begin
                    // stop bit just sampled
                    if (in == 1'b1)
                        next_state = IDLE; // valid stop bit, ready for next byte
                    else
                        next_state = ERROR; // framing error
                end
            end

            ERROR: begin
                if (in == 1'b1)
                    next_state = IDLE; // wait for line idle before resync
                else
                    next_state = ERROR;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule