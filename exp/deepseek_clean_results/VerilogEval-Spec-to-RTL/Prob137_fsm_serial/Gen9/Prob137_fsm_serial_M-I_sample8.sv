module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // Optimized state encoding
    typedef enum logic [1:0] {
        IDLE    = 2'b00,  // Waiting for start bit
        RECEIVE = 2'b01,  // Receiving data bits
        STOP    = 2'b10,  // Checking stop bit
        ERROR   = 2'b11   // Waiting for valid stop bit
    } state_t;

    reg [1:0] state, next_state;
    reg [1:0] bit_count;  // Now counts 0-6 (2 bits)
    reg [7:0] data_reg;
    reg done_reg;
    wire recv_done = (bit_count == 2'b10);  // Terminal count at 6 (7th bit)

    // State transition and data sampling with clock gating
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data_reg <= 0;
            done_reg <= 0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    bit_count <= 0;
                    done_reg <= 0;
                end

                RECEIVE: begin
                    data_reg <= {in, data_reg[7:1]};  // LSB first
                    bit_count <= recv_done ? 2'b00 : bit_count + 1;
                end

                STOP: begin
                    done_reg <= in;  // Only update done_reg in STOP state
                end

                ERROR: begin
                    // No operations needed, just waiting
                end
            endcase
        end
    end

    // Optimized next state logic
    always @(*) begin
        case (state)
            IDLE:    next_state = (~in) ? RECEIVE : IDLE;
            RECEIVE: next_state = recv_done ? STOP : RECEIVE;
            STOP:    next_state = in ? IDLE : ERROR;
            ERROR:   next_state = in ? IDLE : ERROR;
            default: next_state = IDLE;
        endcase
    end

    assign done = done_reg;

endmodule