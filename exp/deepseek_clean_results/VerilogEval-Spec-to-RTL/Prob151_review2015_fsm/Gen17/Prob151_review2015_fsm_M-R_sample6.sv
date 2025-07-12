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

    // State encoding
    localparam IDLE  = 2'b00;
    localparam SHIFT = 2'b01;
    localparam COUNT = 2'b10;
    localparam DONE  = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] pattern;
    reg [1:0] shift_count;

    // Pattern shift register
    always @(posedge clk) begin
        if (reset) begin
            pattern <= 4'b0;
        end else begin
            pattern <= {pattern[2:0], data};
        end
    end

    // Shift counter
    always @(posedge clk) begin
        if (reset || state != SHIFT) begin
            shift_count <= 2'b0;
        end else if (state == SHIFT) begin
            shift_count <= shift_count + 1'b1;
        end
    end

    // State transitions
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: 
                if (pattern == 4'b1101) 
                    next_state = SHIFT;
            
            SHIFT:
                if (shift_count == 2'b11) // Counted 4 cycles
                    next_state = COUNT;
            
            COUNT:
                if (done_counting)
                    next_state = DONE;
            
            DONE:
                if (ack)
                    next_state = IDLE;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting = (state == COUNT);
    assign done = (state == DONE);

endmodule