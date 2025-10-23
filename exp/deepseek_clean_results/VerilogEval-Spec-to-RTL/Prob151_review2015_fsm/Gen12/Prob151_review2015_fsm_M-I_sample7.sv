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
    reg pattern_detected;

    // Pattern detection logic
    always @(posedge clk) begin
        if (reset) begin
            pattern_reg <= 4'b0;
            pattern_detected <= 1'b0;
        end else begin
            pattern_reg <= {pattern_reg[2:0], data};
            pattern_detected <= (state == IDLE) && (pattern_reg == 4'b1101);
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
                next_state = (pattern_reg[1:0] == 2'b11) ? COUNT : SHIFT;
            
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