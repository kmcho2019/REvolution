module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding (binary)
    localparam IDLE      = 2'b00;
    localparam RECEIVE   = 2'b01;
    localparam STOP      = 2'b10;
    localparam WAIT_STOP = 2'b11;

    reg [1:0] state, next_state;

    // Bit counter and data shift register
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    // Next state combinational logic as continuous assignments
    wire start_bit_detected   = (state == IDLE)    && (in == 1'b0);
    wire receiving_last_bit   = (state == RECEIVE) && (bit_cnt == 3'd7);
    wire stop_bit_correct     = (in == 1'b1);
    wire stop_bit_incorrect   = (in == 1'b0);

    assign_next_state next_state_gen (
        .state(state),
        .in(in),
        .start_bit_detected(start_bit_detected),
        .receiving_last_bit(receiving_last_bit),
        .stop_bit_correct(stop_bit_correct),
        .stop_bit_incorrect(stop_bit_incorrect),
        .next_state(next_state)
    );

    // Separate module-like block (inside this file) for next state logic as continuous assignments
    // to keep this clean; synthesized by the tool as combinational logic.
    // This uses continuous assignments and a combinational always block.

    // Implementation of next state logic in a combinational always block for synthesis:
    always @(*) begin
        case(state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE; // Start bit detected
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_cnt == 3'd7)
                    next_state = STOP; // All data bits received
                else
                    next_state = RECEIVE;
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE; // Correct stop bit, back to idle
                else
                    next_state = WAIT_STOP; // Bad stop bit, wait for valid stop
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE; // Valid stop bit received, idle
                else
                    next_state = WAIT_STOP; // Keep waiting
            end

            default: next_state = IDLE;
        endcase
    end

    // State register update
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter: increment only during RECEIVE state
    wire bit_cnt_enable = (state == RECEIVE);

    always @(posedge clk) begin
        if (reset)
            bit_cnt <= 3'd0;
        else if (bit_cnt_enable)
            bit_cnt <= bit_cnt + 3'd1;
        else
            bit_cnt <= 3'd0;
    end

    // Shift register: shift left, new bit goes into bit 0 (LSB first)
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 8'd0;
        else if (state == RECEIVE)
            shift_reg <= {in, shift_reg[7:1]};
    end

    // Output logic and done signal generation
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            done <= 1'b0;
            // Assert done for one cycle when correct stop bit received
            if ((state == STOP) && (in == 1'b1)) begin
                done <= 1'b1;
                out_byte <= shift_reg;
            end
        end
    end

endmodule