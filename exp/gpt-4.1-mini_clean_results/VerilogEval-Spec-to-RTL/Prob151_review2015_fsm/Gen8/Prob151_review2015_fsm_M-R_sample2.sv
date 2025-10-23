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

    // One-hot state encoding
    localparam IDLE  = 4'b0001;
    localparam SHIFT = 4'b0010;
    localparam COUNT = 4'b0100;
    localparam DONE  = 4'b1000;

    reg [3:0] state, next_state;

    // Pattern detection shift register, only shifted in IDLE
    reg [3:0] pattern_shift;

    // Shift counter: counts 0 to 3 during SHIFT
    reg [1:0] shift_count;

    // Pattern matched signal
    wire pattern_detected = (pattern_shift == 4'b1101);

    // Sequential logic: State and pattern shift register updates
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'b0000;
            shift_count <= 2'b00;
        end else begin
            state <= next_state;

            if (state == IDLE) begin
                // Shift in data only in IDLE to detect pattern
                pattern_shift <= {pattern_shift[2:0], data};
            end else begin
                // Clear pattern shift register outside IDLE
                pattern_shift <= 4'b0000;
            end

            if (state == SHIFT) begin
                // Increment shift_count during SHIFT
                shift_count <= shift_count + 2'b01;
            end else begin
                // Reset shift_count outside SHIFT
                shift_count <= 2'b00;
            end
        end
    end

    // Next state combinational logic
    always_comb begin
        next_state = state;  // default hold
        case (state)
            IDLE: begin
                if (pattern_detected)
                    next_state = SHIFT;
            end
            SHIFT: begin
                if (shift_count == 2'b11)  // after 4 cycles (count 0..3)
                    next_state = COUNT;
            end
            COUNT: begin
                if (done_counting)
                    next_state = DONE;
            end
            DONE: begin
                if (ack)
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Outputs as Moore outputs from state bits
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule