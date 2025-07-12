module TopModule (
    input  clk,
    input  in,
    input  reset,
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding
    localparam IDLE      = 2'd0;
    localparam RECEIVE   = 2'd1;
    localparam STOP      = 2'd2;
    localparam WAIT_STOP = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;    // counts 0..7 data bits
    reg [7:0] data_shift;

    // Combinational next-state logic
    always @(*) begin
        case (state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                // After receiving 8 bits, move to STOP
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end

            STOP: begin
                // Valid stop bit -> IDLE, else WAIT_STOP
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            WAIT_STOP: begin
                // Wait for line idle (1) before next IDLE
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential state update
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Sequential logic for bit_count and data_shift with clock enables
    always @(posedge clk) begin
        if (reset) begin
            bit_count  <= 3'd0;
            data_shift <= 8'd0;
        end else begin
            case (state)
                IDLE: begin
                    // Clear registers on detecting start bit
                    if (in == 1'b0) begin
                        bit_count  <= 3'd0;
                        data_shift <= 8'd0;
                    end
                end

                RECEIVE: begin
                    // Shift in LSB first each clock
                    data_shift <= {in, data_shift[7:1]};
                    bit_count  <= bit_count + 1;
                end

                default: begin
                    // Hold values in other states
                    bit_count  <= bit_count;
                    data_shift <= data_shift;
                end
            endcase
        end
    end

    // Sequential output logic and done pulse generation
    always @(posedge clk) begin
        if (reset) begin
            out_byte <= 8'd0;
            done     <= 1'b0;
        end else begin
            done <= 1'b0; // default done low

            if (state == STOP && in == 1'b1) begin
                out_byte <= data_shift;
                done     <= 1'b1;
            end
        end
    end

endmodule