module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding (binary)
    localparam [1:0]
        IDLE  = 2'b00,
        DATA  = 2'b01,
        STOP  = 2'b10,
        ERROR = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;      // 3-bit counter for data bits [0..7]
    reg [7:0] shift_reg;      // 8-bit shift register for data bits

    // Sequential logic: state, counters, shift register and done output
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0;  // Default no pulse

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                DATA: begin
                    // Shift right, input bit into MSB to maintain LSB-first order
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1;
                end

                STOP: begin
                    // If stop bit is correct (in==1), done pulse asserted
                    if (in == 1'b1)
                        done <= 1'b1;
                    bit_count <= 3'd0;
                end

                ERROR: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                default: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

    // Combinational next-state logic
    always @(*) begin
        next_state = state;

        case (state)
            IDLE: begin
                if (in == 1'b0)         // Detect start bit (line goes low)
                    next_state = DATA;
                else
                    next_state = IDLE;
            end

            DATA: begin
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;   // Valid stop bit, go to IDLE for next frame
                else
                    next_state = ERROR;  // Framing error: missing stop bit
            end

            ERROR: begin
                if (in == 1'b1)        // Wait for line to return to stop bit level
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule