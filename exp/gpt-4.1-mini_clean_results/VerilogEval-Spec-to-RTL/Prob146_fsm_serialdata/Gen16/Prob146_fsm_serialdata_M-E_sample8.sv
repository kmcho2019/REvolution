module TopModule (
    input        clk,
    input        in,
    input        reset,
    output reg [7:0] out_byte,
    output reg       done
);

    // State encoding as localparams for clear and small FSM
    localparam IDLE       = 2'd0;
    localparam RECEIVE    = 2'd1;
    localparam STOP_CHECK = 2'd2;
    localparam ERROR_WAIT = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_index;  // Counts bits 0..7 for data bits
    reg [7:0] data_reg;

    // Next state logic combinational
    always @(*) begin
        case(state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                // After receiving 8 bits, go to stop bit check
                if (bit_index == 3'd7)
                    next_state = STOP_CHECK;
                else
                    next_state = RECEIVE;
            end

            STOP_CHECK: begin
                // If stop bit correct (1), go to IDLE with done pulse
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end

            ERROR_WAIT: begin
                // Wait for line idle to retry
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end

            default: next_state = IDLE;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Bit index and data register update
    always @(posedge clk) begin
        if (reset) begin
            bit_index <= 3'd0;
            data_reg <= 8'd0;
        end else begin
            case(state)
                IDLE: begin
                    // Reset bit_index on detection of start bit to prepare for receive
                    if (in == 1'b0)
                        bit_index <= 3'd0;
                end

                RECEIVE: begin
                    // Store incoming bit at bit_index position (LSB first)
                    data_reg[bit_index] <= in;
                    bit_index <= bit_index + 1;
                end

                default: begin
                    // Hold bit_index and data_reg elsewhere
                    bit_index <= bit_index;
                    data_reg <= data_reg;
                end
            endcase
        end
    end

    // Output and done pulse logic
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // Default no pulse

            if ((state == STOP_CHECK) && (in == 1'b1)) begin
                out_byte <= data_reg;
                done <= 1'b1;
            end
        end
    end

endmodule