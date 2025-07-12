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

    // State encoding (binary)
    typedef enum logic [1:0] {
        SEARCH = 2'b00,
        SHIFT  = 2'b01,
        COUNT  = 2'b10,
        DONE   = 2'b11
    } state_t;

    state_t state, next_state;

    reg [3:0] shift_reg;      // Shift register holding last 4 bits of serial input
    reg [1:0] shift_count;    // Counts shift cycles in SHIFT state: 0..3

    // Shift in new data bit synchronously at every clock, even in states other than SEARCH
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0000;
        end else begin
            shift_reg <= {shift_reg[2:0], data};
        end
    end

    // State register and shift_count update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_count <= 2'b00;
        end else begin
            state <= next_state;

            if (state == SHIFT)
                shift_count <= shift_count + 2'b01;
            else
                shift_count <= 2'b00;
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;  // default hold

        case(state)
            SEARCH: begin
                // Detect pattern 1101 in shift_reg and move to SHIFT if found
                if (shift_reg == 4'b1101)
                    next_state = SHIFT;
                else
                    next_state = SEARCH;
            end

            SHIFT: begin
                // After 4 shift cycles (shift_count from 0 to 3), move to COUNT
                if (shift_count == 2'b11)
                    next_state = COUNT;
                else
                    next_state = SHIFT;
            end

            COUNT: begin
                // Wait for done_counting signal
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end

            DONE: begin
                // Wait for ack signal to return to SEARCH
                if (ack)
                    next_state = SEARCH;
                else
                    next_state = DONE;
            end

            default: next_state = SEARCH;
        endcase
    end

    // Registered outputs to align with FSM state at clock edge
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b0;
            counting  <= 1'b0;
            done      <= 1'b0;
        end else begin
            // Assert shift_ena only during SHIFT state
            shift_ena <= (state == SHIFT);

            // Assert counting only in COUNT state
            counting  <= (state == COUNT);

            // Assert done only in DONE state
            done      <= (state == DONE);
        end
    end

endmodule