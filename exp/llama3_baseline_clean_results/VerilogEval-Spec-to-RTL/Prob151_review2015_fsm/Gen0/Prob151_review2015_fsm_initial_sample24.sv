module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

// Define the states
enum logic [2:0] {IDLE, SHIFT, COUNTING, DONE} state, next_state;

// Define the shift counter
reg [1:0] shift_count;

// Define the pattern detector
reg [3:0] pattern;

// Define the pattern detector logic
always @(posedge clk) begin
    if (reset) begin
        pattern <= 4'b0000;
    end else begin
        pattern <= {pattern[2:0], data};
    end
end

// Define the next state logic
always @(*) begin
    case (state)
        IDLE: begin
            if (pattern == 4'b1101) begin
                next_state = SHIFT;
            end else begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            if (shift_count == 4'd3) begin
                next_state = COUNTING;
            end else begin
                next_state = SHIFT;
            end
        end
        COUNTING: begin
            if (done_counting) begin
                next_state = DONE;
            end else begin
                next_state = COUNTING;
            end
        end
        DONE: begin
            if (ack) begin
                next_state = IDLE;
            end else begin
                next_state = DONE;
            end
        end
        default: next_state = IDLE;
    endcase
end

// Define the output logic
always @(*) begin
    case (state)
        IDLE: begin
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b0;
        end
        SHIFT: begin
            shift_ena = 1'b1;
            counting = 1'b0;
            done = 1'b0;
        end
        COUNTING: begin
            shift_ena = 1'b0;
            counting = 1'b1;
            done = 1'b0;
        end
        DONE: begin
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b1;
        end
        default: begin
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b0;
        end
    endcase
end

// Define the shift counter logic
always @(posedge clk) begin
    if (reset) begin
        shift_count <= 4'd0;
    end else if (state == SHIFT) begin
        if (shift_ena) begin
            shift_count <= shift_count + 1;
        end
    end else begin
        shift_count <= 4'd0;
    end
end

// Define the state register
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

endmodule