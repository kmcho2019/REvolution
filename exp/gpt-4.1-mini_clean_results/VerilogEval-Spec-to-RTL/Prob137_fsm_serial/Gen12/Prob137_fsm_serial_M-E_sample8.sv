module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire done
);

    // State encoding (2 bits)
    localparam IDLE      = 2'd0;
    localparam RECEIVE   = 2'd1;
    localparam WAIT_STOP = 2'd2;

    reg [1:0] state, next_state;
    reg [2:0] bit_idx;      // counts 0 to 7 data bits
    reg [7:0] shift_reg;    // shift register: shift left, LSB first

    // Next-state logic and bit index update
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_idx == 3'd7)
                    next_state = WAIT_STOP;
                else
                    next_state = RECEIVE;
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state, bit counter, shift register
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_idx   <= 3'd0;
            shift_reg <= 8'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    bit_idx   <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift left, load incoming bit into LSB to maintain LSB-first order
                    shift_reg <= {shift_reg[6:0], in};
                    bit_idx   <= bit_idx + 1;
                end

                WAIT_STOP: begin
                    bit_idx   <= 3'd0;
                    shift_reg <= shift_reg; // keep data stable
                end

                default: begin
                    bit_idx   <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

    // Mealy done pulse: High only in WAIT_STOP when stop bit is correct (in == 1)
    assign done = (state == WAIT_STOP) && (in == 1'b1);

endmodule