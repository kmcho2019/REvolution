module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg done
);

    // One-hot state encoding for clarity and potential optimization
    localparam IDLE      = 3'b001;
    localparam RECEIVE   = 3'b010;
    localparam STOP_WAIT = 3'b100;

    reg [2:0] state, next_state;

    reg [2:0] bit_count;    // count data bits received (0..7)
    reg [7:0] data_reg;     // store data bits, LSB first (bit0 = first received bit)

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)      // start bit detected
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP_WAIT;
                else
                    next_state = RECEIVE;
            end

            STOP_WAIT: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = STOP_WAIT;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state update, bit count, data shift, done signal
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            data_reg  <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // Default done deasserted each cycle
            done <= 1'b0;

            case(state)
                IDLE: begin
                    bit_count <= 3'd0;
                    data_reg  <= 8'd0;
                end

                RECEIVE: begin
                    // Shift right and insert new bit at MSB (bit 7).
                    // This way, the first received bit ends in data_reg[0], LSB first.
                    data_reg <= {in, data_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end

                STOP_WAIT: begin
                    // If stop bit is correct, assert done for one cycle
                    if (in == 1'b1)
                        done <= 1'b1;
                    // else keep waiting
                end

                default: begin
                    bit_count <= 3'd0;
                    data_reg  <= 8'd0;
                end
            endcase
        end
    end

endmodule