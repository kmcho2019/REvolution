module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding
    typedef enum logic [1:0] {IDLE = 2'd0, DATA = 2'd1, STOP = 2'd2, ERROR = 2'd3} state_t;
    state_t state, next_state;

    reg [2:0] bit_count, next_bit_count;
    reg [7:0] shift_reg, next_shift_reg;
    reg next_done;

    // Combinational next-state logic and outputs
    always @(*) begin
        next_state     = state;
        next_bit_count = bit_count;
        next_shift_reg = shift_reg;
        next_done      = 1'b0;

        case(state)
            IDLE: begin
                if (in == 1'b0) begin
                    next_state     = DATA;
                    next_bit_count = 3'd0;
                    next_shift_reg = 8'd0;
                end else begin
                    next_state     = IDLE;
                    next_bit_count = 3'd0;
                    next_shift_reg = 8'd0;
                end
            end
            DATA: begin
                next_shift_reg = {in, shift_reg[7:1]};  // Shift right to put new bit in LSB (LSB first)
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
                next_bit_count = bit_count + 1;
            end
            STOP: begin
                if (in == 1'b1) begin
                    next_done  = 1'b1;
                    next_state = IDLE;
                end else begin
                    next_state = ERROR;
                end
                next_bit_count = 3'd0;
                next_shift_reg = 8'd0;
            end
            ERROR: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
                next_bit_count = 3'd0;
                next_shift_reg = 8'd0;
            end
            default: begin
                next_state     = IDLE;
                next_bit_count = 3'd0;
                next_shift_reg = 8'd0;
            end
        endcase
    end

    // Synchronous state and registers update
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state     <= next_state;
            bit_count <= next_bit_count;
            shift_reg <= next_shift_reg;
            done      <= next_done;
        end
    end

endmodule