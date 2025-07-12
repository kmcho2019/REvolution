module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding - optimized for timing and power
    typedef enum logic [1:0] {
        IDLE,      // Waiting for start bit (0) or missing stop bit
        RECEIVE,   // Receiving 8 data bits
        STOP       // Checking stop bit (1)
    } state_t;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_shift;
    reg done_reg;
    wire receive_done = (bit_count == 3'd7); // Terminal count signal

    // Sequential logic with enable conditions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            data_shift <= 8'b0;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;
            done_reg <= 1'b0;  // Default to 0

            case (state)
                IDLE: begin
                    bit_count <= 3'b0;
                end

                RECEIVE: begin
                    if (!receive_done) begin  // Only update when needed
                        data_shift <= {in, data_shift[7:1]};  // LSB first
                        bit_count <= bit_count + 1;
                    end
                end

                STOP: begin
                    if (in) begin  // Valid stop bit
                        done_reg <= 1'b1;
                    end
                end
            endcase
        end
    end

    // Optimized combinational next state logic
    always @(*) begin
        case (state)
            IDLE:    next_state = (~in) ? RECEIVE : IDLE;
            RECEIVE: next_state = receive_done ? STOP : RECEIVE;
            STOP:    next_state = in ? IDLE : IDLE; // Wait in IDLE for stop bit
            default: next_state = IDLE;
        endcase
    end

    assign done = done_reg;

endmodule