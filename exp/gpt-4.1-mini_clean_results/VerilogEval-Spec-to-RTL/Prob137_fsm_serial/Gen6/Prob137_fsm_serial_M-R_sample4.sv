module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // Define states with enum style
    typedef enum logic [1:0] {
        IDLE        = 2'b00,
        RECEIVE     = 2'b01,
        STOP_CHECK  = 2'b10,
        WAIT_STOP   = 2'b11
    } state_t;

    state_t state, next_state;
    reg [2:0] bit_count;      // counts from 0 to 7 (8 bits)
    reg [7:0] data_reg;

    // Combinational logic: Next state calculation
    always @* begin
        case (state)
            IDLE: 
                if (in == 1'b0) 
                    next_state = RECEIVE;  // start bit detected
                else
                    next_state = IDLE;

            RECEIVE:
                if (bit_count == 3'd7)
                    next_state = STOP_CHECK;
                else
                    next_state = RECEIVE;

            STOP_CHECK:
                if (in == 1'b1)
                    next_state = IDLE;      // valid stop bit
                else
                    next_state = WAIT_STOP; // invalid stop bit, wait for stop bit

            WAIT_STOP:
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state, bit_count, data_reg, done signal
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            data_reg  <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // Default done low; set high only in STOP_CHECK state with valid stop bit
            done <= 1'b0;

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    data_reg  <= 8'd0;
                end

                RECEIVE: begin
                    // Shift data left by one, inserting 'in' at LSB to keep LSB-first order
                    data_reg <= {in, data_reg[7:1]};
                    bit_count <= bit_count + 1;
                end

                STOP_CHECK: begin
                    if (in == 1'b1) begin
                        done <= 1'b1; // Pulse done when valid stop bit detected
                        // bit_count and data_reg remain unchanged
                    end
                end

                WAIT_STOP: begin
                    // Hold current data_reg and bit_count, waiting for stop bit
                end
            endcase
        end
    end

endmodule