module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // One-hot state encoding for better timing
    localparam [3:0]
        IDLE  = 4'b0001,
        DATA  = 4'b0010,
        STOP  = 4'b0100,
        ERROR = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;       // 3-bit counter for bits received
    reg [7:0] shift_reg;       // Shift register for data bits LSB first

    wire data_enable = (state == DATA);

    // Sequential logic for state, bit_count, shift_reg, and done pulse
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // Default done deasserted
            done <= 1'b0;

            // Update bit_count only in DATA state
            if (data_enable)
                bit_count <= bit_count + 1;
            else if ((state == IDLE) || (state == STOP) || (state == ERROR))
                bit_count <= 3'd0;

            // Shift register update only in DATA state
            if (data_enable)
                shift_reg <= {shift_reg[6:0], in};
            else if ((state == IDLE) || (state == STOP) || (state == ERROR))
                shift_reg <= 8'd0;

            // Generate done pulse only in STOP state with valid stop bit (1)
            if (state == STOP && in == 1'b1)
                done <= 1'b1;
        end
    end

    // Combinational logic for next state determination
    always @(*) begin
        // Default next state is current state
        next_state = state;

        case(state)
            IDLE: begin
                if (in == 1'b0)      // Start bit detected (0)
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
                    next_state = IDLE;    // Valid stop bit, ready for next byte
                else
                    next_state = ERROR;   // Framing error, wait for stop bit
            end

            ERROR: begin
                if (in == 1'b1)         // Wait until stop bit seen
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule