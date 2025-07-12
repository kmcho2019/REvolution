module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);
    // State encoding
    localparam IDLE       = 2'd0;
    localparam RECEIVE    = 2'd1;
    localparam CHECK_STOP = 2'd2;
    localparam WAIT_STOP  = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;
    reg done_next;
    reg [7:0] out_byte_next;

    // Sequential logic: state, registers, outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 3'd0;
            shift_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            bit_cnt <= (next_state == RECEIVE) ? ((bit_cnt == 3'd7) ? bit_cnt : bit_cnt + 1) : 3'd0;

            // Shift register update only in RECEIVE state
            if (state == RECEIVE) begin
                // Shift in LSB first
                shift_reg <= {in, shift_reg[7:1]};
            end else if (next_state == IDLE) begin
                shift_reg <= 8'd0;
            end

            out_byte <= out_byte_next;
            done <= done_next;
        end
    end

    // Combinational next-state and output logic
    always @(*) begin
        // Defaults
        next_state = state;
        done_next = 1'b0;
        out_byte_next = out_byte;

        case (state)
            IDLE: begin
                if (in == 1'b0) // start bit detected
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_cnt == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end

            CHECK_STOP: begin
                if (in == 1'b1) begin
                    // Valid stop bit
                    next_state = IDLE;
                    done_next = 1'b1;
                    out_byte_next = shift_reg;
                end else begin
                    // Invalid stop bit
                    next_state = WAIT_STOP;
                end
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

endmodule