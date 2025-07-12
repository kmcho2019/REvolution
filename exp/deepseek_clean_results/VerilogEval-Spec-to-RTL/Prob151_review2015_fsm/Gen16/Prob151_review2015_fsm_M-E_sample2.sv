module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // Gray-coded state encoding
    localparam [1:0] IDLE  = 2'b00;
    localparam [1:0] SHIFT = 2'b01;
    localparam [1:0] COUNT = 2'b11;
    localparam [1:0] DONE  = 2'b10;

    reg [1:0] state, next_state;
    reg [3:0] pattern;

    // Continuous pattern shifting
    always @(posedge clk) begin
        if (reset) begin
            pattern <= 4'b0;
        end else if (state == IDLE || state == SHIFT) begin
            pattern <= {pattern[2:0], data};
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
                if (&pattern[1:0]) // After 2 more shifts (total 4)
                    next_state = COUNT;
            
            COUNT:
                if (done_counting)
                    next_state = DONE;
            
            DONE:
                if (ack)
                    next_state = IDLE;
        endcase
    end

    // Sequential state update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Registered outputs
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
        end else begin
            shift_ena <= (state == SHIFT);
            counting <= (state == COUNT);
            done <= (state == DONE);
        end
    end

endmodule