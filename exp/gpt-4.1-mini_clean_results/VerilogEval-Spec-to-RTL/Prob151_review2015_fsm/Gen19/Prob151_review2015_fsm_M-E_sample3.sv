module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output wire shift_ena,
    output wire counting,
    output wire done
);

    // FSM states (2-bit encoding for main states)
    localparam IDLE  = 2'b00;
    localparam SHIFT = 2'b01;
    localparam COUNT = 2'b10;
    localparam DONE  = 2'b11;

    reg [1:0] state, next_state;

    // Shift register (2 bits) to detect pattern 1101
    // We'll keep last 4 bits in a 4-bit shift_reg for easy pattern detect
    reg [3:0] shift_reg;

    // 2-bit counter for shift cycles (0 to 3)
    reg [1:0] shift_count, shift_count_next;

    // Pattern detection: pattern 1101 is 4'b1101 = 4'b1101 = 13 decimal
    wire pattern_detected = (shift_reg == 4'b1101);

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0000;
            shift_count <= 2'b00;
        end else begin
            state <= next_state;
            shift_reg <= {shift_reg[2:0], data};
            shift_count <= shift_count_next;
        end
    end

    // Next state logic and shift_count update
    always @(*) begin
        // Default assignments
        next_state = state;
        shift_count_next = shift_count;

        case (state)
            IDLE: begin
                // Stay in IDLE until pattern detected
                if (pattern_detected)
                    next_state = SHIFT;
                shift_count_next = 2'b00; // reset counter at pattern start
            end

            SHIFT: begin
                if (shift_count == 2'd3) begin
                    next_state = COUNT;
                    // shift_count doesn't need update here
                end else begin
                    shift_count_next = shift_count + 1;
                end
            end

            COUNT: begin
                if (done_counting)
                    next_state = DONE;
            end

            DONE: begin
                if (ack)
                    next_state = IDLE;
            end
        endcase
    end

    // Output logic: Moore outputs based on state
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule