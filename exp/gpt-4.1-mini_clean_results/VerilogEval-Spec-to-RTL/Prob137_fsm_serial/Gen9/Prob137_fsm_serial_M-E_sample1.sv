module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire done
);

    // FSM state encoding (binary)
    localparam [1:0]
        IDLE       = 2'd0,
        RECEIVE    = 2'd1,
        STOP_CHECK = 2'd2,
        WAIT_STOP  = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // FSM state transition and registers
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
        end else begin
            state <= next_state;
            if (state == RECEIVE) begin
                bit_count <= bit_count + 3'd1;
                // Shift left, LSB first: shift_reg = {in, shift_reg[7:1]} would put in MSB, so instead shift right
                // To shift in LSB first, shift right by 1 and insert new bit at MSB would be MSB first
                // So shift left and put in LSB:
                shift_reg <= {in, shift_reg[7:1]}; // This inserts in MSB, so MSB first -> wrong
                // Actually to shift in LSB first:
                // shift_reg <= {shift_reg[6:0], in};
                shift_reg <= {shift_reg[6:0], in};
            end else begin
                bit_count <= 3'd0;
                shift_reg <= shift_reg; // Hold value
            end
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE; // Start bit detected
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP_CHECK;
                else
                    next_state = RECEIVE;
            end

            STOP_CHECK: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
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

    // Done pulse combinational generation:
    // done is high only for one clock cycle immediately after STOP_CHECK state if stop bit was correct (in==1).
    // Since done is an output wire, create a register to detect this transition:
    reg done_reg;
    always @(posedge clk) begin
        if (reset)
            done_reg <= 1'b0;
        else begin
            // done pulse when current state is STOP_CHECK and input bit is 1
            if ((state == STOP_CHECK) && (in == 1'b1))
                done_reg <= 1'b1;
            else
                done_reg <= 1'b0;
        end
    end
    assign done = done_reg;

endmodule