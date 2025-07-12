module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // FSM state encoding
    localparam IDLE    = 2'd0;
    localparam DATA    = 2'd1;
    localparam STOP    = 2'd2;
    localparam RECOVER = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // State and data registers update
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                DATA: begin
                    // Shift right: insert new bit into MSB; first bit received is LSB,
                    // shifting right accumulates LSB first correctly.
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end

                STOP: begin
                    // No shift, bit_count remains
                end

                RECOVER: begin
                    // No shift, wait for stop bit recovery
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
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
                // Check stop bit
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = RECOVER;
            end

            RECOVER: begin
                // Wait for stop bit (line = 1)
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = RECOVER;
            end

            default: next_state = IDLE;
        endcase
    end

    // done signal: synchronous, asserted one cycle when valid stop bit detected
    always @(posedge clk) begin
        if (reset)
            done <= 1'b0;
        else if (state == STOP && in == 1'b1)
            done <= 1'b1;
        else
            done <= 1'b0;
    end

endmodule