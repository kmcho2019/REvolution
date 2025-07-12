module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output reg  shift_ena,
    output reg  counting,
    output reg  done
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE  = 2'd0,  // searching pattern
        SHIFT = 2'd1,  // shift delay bits for 4 cycles
        COUNT = 2'd2,  // waiting for done_counting
        DONE  = 2'd3   // done, waiting for ack
    } state_t;

    state_t state, next_state;

    reg [3:0] shift_reg;      // shift register to detect pattern
    reg [1:0] shift_count;    // counts 0 to 3 during SHIFT

    // Shift in data on every clock
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
        end else begin
            shift_reg <= {shift_reg[2:0], data};
        end
    end

    // State register and shift_count counter
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;
            if (state == SHIFT)
                shift_count <= shift_count + 2'd1;
            else
                shift_count <= 2'd0;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                // Detect pattern '1101' in shift_reg
                // Most recent bit in LSB: shift_reg = {oldest, ..., newest=data}
                // So pattern = 4'b1101 corresponds to bits [3:0] = 4'b1101
                if (shift_reg == 4'b1101)
                    next_state = SHIFT;
                else
                    next_state = IDLE;
            end
            SHIFT: begin
                if (shift_count == 2'd3) // after 4 cycles (0..3)
                    next_state = COUNT;
                else
                    next_state = SHIFT;
            end
            COUNT: begin
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end
            DONE: begin
                if (ack)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end
        endcase
    end

    // Outputs
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting  = (state == COUNT);
        done      = (state == DONE);
    end

endmodule