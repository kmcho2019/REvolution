module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

reg [2:0] state;
reg [2:0] nextState;
reg [3:0] shift_counter;
reg pattern_detected;

// State encoding
parameter IDLE = 3'b000;
parameter SHIFT = 3'b001;
parameter COUNTING = 3'b010;
parameter DONE = 3'b011;

// Pattern detection logic
reg [3:0] pattern;
always @(posedge clk) begin
    if (reset) begin
        pattern <= 4'b0000;
    end else begin
        pattern <= {pattern[2:0], data};
        if (pattern == 4'b1101) begin
            pattern_detected <= 1'b1;
        end else begin
            pattern_detected <= 1'b0;
        end
    end
end

// Next-state logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_counter <= 4'b0000;
    end else begin
        state <= nextState;
        if (state == SHIFT) begin
            shift_counter <= shift_counter + 1'b1;
        end else begin
            shift_counter <= 4'b0000;
        end
    end
end

// Output logic
always @(*) begin
    shift_ena = 1'b0;
    counting = 1'b0;
    done = 1'b0;
    
    case (state)
        IDLE: begin
            if (pattern_detected) begin
                nextState = SHIFT;
            end else begin
                nextState = IDLE;
            end
        end
        SHIFT: begin
            shift_ena = 1'b1;
            if (shift_counter == 4'b1000) begin
                nextState = COUNTING;
            end else begin
                nextState = SHIFT;
            end
        end
        COUNTING: begin
            counting = 1'b1;
            if (done_counting) begin
                nextState = DONE;
            end else begin
                nextState = COUNTING;
            end
        end
        DONE: begin
            done = 1'b1;
            if (ack) begin
                nextState = IDLE;
            end else begin
                nextState = DONE;
            end
        end
        default: nextState = IDLE;
    endcase
end

endmodule