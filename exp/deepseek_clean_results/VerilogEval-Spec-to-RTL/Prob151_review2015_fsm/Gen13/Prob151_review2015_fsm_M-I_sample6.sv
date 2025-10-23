module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

    // One-hot state encoding
    localparam IDLE  = 4'b0001;
    localparam SHIFT = 4'b0010;
    localparam COUNT = 4'b0100;
    localparam DONE  = 4'b1000;

    reg [3:0] state, next_state;
    reg [3:0] pattern_reg;
    reg [1:0] shift_counter;
    wire pattern_detected;

    // Combinatorial pattern detection
    assign pattern_detected = (state == IDLE) && (pattern_reg == 4'b1101);

    // Pattern shift register
    always @(posedge clk) begin
        if (reset) begin
            pattern_reg <= 4'b0;
        end else if (state == IDLE) begin
            pattern_reg <= {pattern_reg[2:0], data};
        end else if (state == SHIFT) begin
            pattern_reg <= 4'b0; // Clear after detection
        end
    end

    // Shift counter for 4 cycles
    always @(posedge clk) begin
        if (reset || state != SHIFT) begin
            shift_counter <= 2'b0;
        end else begin
            shift_counter <= shift_counter + 1;
        end
    end

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (1'b1)
            state[0]: // IDLE
                next_state = pattern_detected ? SHIFT : IDLE;
            
            state[1]: // SHIFT
                next_state = (shift_counter == 2'b11) ? COUNT : SHIFT;
            
            state[2]: // COUNT
                next_state = done_counting ? DONE : COUNT;
            
            state[3]: // DONE
                next_state = ack ? IDLE : DONE;
            
            default:
                next_state = IDLE;
        endcase
    end

    // Output assignments
    assign shift_ena = state[1]; // SHIFT state
    assign counting = state[2];  // COUNT state
    assign done = state[3];      // DONE state

endmodule