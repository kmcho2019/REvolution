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

    // One-hot state encoding for clarity and potentially faster logic
    localparam IDLE  = 4'b0001;
    localparam SHIFT = 4'b0010;
    localparam COUNT = 4'b0100;
    localparam DONE  = 4'b1000;

    reg [3:0] state, next_state;

    // Shift register to detect pattern 1101 (4 bits)
    reg [3:0] pattern_shift;

    // Counter to track shift cycles (0..3)
    reg [1:0] shift_count;

    // Pattern match combinational signal
    wire pattern_match;
    assign pattern_match = (pattern_shift == 4'b1101);

    // Update pattern shift register synchronously
    always @(posedge clk) begin
        if (reset) begin
            pattern_shift <= 4'b0000;
        end else begin
            pattern_shift <= {pattern_shift[2:0], data};
        end
    end

    // State register with synchronous reset
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

    // Next state combinational logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (pattern_match)
                    next_state = SHIFT;
                else
                    next_state = IDLE;
            end
            SHIFT: begin
                if (shift_count == 2'd3)
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
            default: next_state = IDLE;
        endcase
    end

    // Outputs: Moore outputs depending only on current state
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule