module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

// Define the states
parameter IDLE = 0, SHIFT = 1, COUNT = 2, DONE_WAIT = 3;

reg [1:0] state;
reg [1:0] next_state;

// Define the pattern register
reg [3:0] pattern;

// Define the shift counter
reg [1:0] shift_count;
reg [1:0] next_shift_count;

// Define the outputs
reg shift_ena_reg;
reg counting_reg;
reg done_reg;

// Next state logic
always @(*) begin
    case (state)
        IDLE: begin
            if (pattern == 4'b1101) begin
                next_state = SHIFT;
            end else if (reset) begin
                next_state = IDLE;
            end else begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            if (shift_count == 4) begin
                next_state = COUNT;
            end else begin
                next_state = SHIFT;
            end
        end
        COUNT: begin
            if (done_counting) begin
                next_state = DONE_WAIT;
            end else begin
                next_state = COUNT;
            end
        end
        DONE_WAIT: begin
            if (ack) begin
                next_state = IDLE;
            end else begin
                next_state = DONE_WAIT;
            end
        end
    endcase
end

// Output logic
always @(*) begin
    case (state)
        IDLE: begin
            shift_ena_reg = 0;
            counting_reg = 0;
            done_reg = 0;
        end
        SHIFT: begin
            shift_ena_reg = 1;
            counting_reg = 0;
            done_reg = 0;
        end
        COUNT: begin
            shift_ena_reg = 0;
            counting_reg = 1;
            done_reg = 0;
        end
        DONE_WAIT: begin
            shift_ena_reg = 0;
            counting_reg = 0;
            done_reg = 1;
        end
    endcase
end

// Pattern register logic
always @(posedge clk) begin
    if (reset) begin
        pattern <= 0;
        shift_count <= 0;
    end else if (state == IDLE) begin
        pattern <= {pattern[2:0], data};
    end else if (state == SHIFT) begin
        shift_count <= shift_count + 1;
    end else begin
        pattern <= 0;
        shift_count <= 0;
    end
end

// State register logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

assign shift_ena = shift_ena_reg;
assign counting = counting_reg;
assign done = done_reg;

endmodule