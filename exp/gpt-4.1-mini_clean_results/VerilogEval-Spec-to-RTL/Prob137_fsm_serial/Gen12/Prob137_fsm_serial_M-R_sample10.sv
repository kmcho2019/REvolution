module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding (binary)
    localparam IDLE       = 2'b00;
    localparam RECEIVE    = 2'b01;
    localparam CHECK_STOP = 2'b10;
    localparam WAIT_STOP  = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count, next_bit_count;
    reg [7:0] shift_reg, next_shift_reg;
    reg       done_reg;

    // Next-state and next-data logic (combinational)
    always @(*) begin
        // Default assignments to hold current values
        next_state     = state;
        next_bit_count = bit_count;
        next_shift_reg = shift_reg;
        done_reg       = 1'b0;

        case (state)
            IDLE: begin
                next_bit_count = 3'd0;
                next_shift_reg = 8'd0;
                if (in == 1'b0)
                    next_state = RECEIVE;
            end
            RECEIVE: begin
                // Shift in new bit LSB first: shift right, new bit into MSB
                next_shift_reg = {in, shift_reg[7:1]};
                next_bit_count = bit_count + 1'b1;
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP;
            end
            CHECK_STOP: begin
                if (in == 1'b1) begin
                    done_reg = 1'b1;
                    next_state = IDLE;
                end else begin
                    next_state = WAIT_STOP;
                end
                next_bit_count = 3'd0;
                next_shift_reg = 8'd0;
            end
            WAIT_STOP: begin
                next_bit_count = 3'd0;
                next_shift_reg = 8'd0;
                if (in == 1'b1)
                    next_state = IDLE;
            end
            default: begin
                next_state     = IDLE;
                next_bit_count = 3'd0;
                next_shift_reg = 8'd0;
                done_reg       = 1'b0;
            end
        endcase
    end

    // State and output registers (sequential)
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
            done      <= done_reg;
        end
    end

endmodule