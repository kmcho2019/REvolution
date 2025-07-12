module TopModule(
    input           clk,
    input           reset,
    input           data,
    input           done_counting,
    input           ack,
    output          shift_ena,
    output          counting,
    output          done
);

// Define states
parameter IDLE = 3'b000;
parameter SHIFT = 3'b001;
parameter COUNT = 3'b010;
parameter DONE_WAIT = 3'b011;

reg [2:0] state;
reg [2:0] next_state;

reg [3:0] shift_count;

// Pattern detection logic
reg [3:0] pattern;

// Output logic
assign shift_ena = (state == SHIFT);
assign counting = (state == COUNT);
assign done = (state == DONE_WAIT);

always @(*) begin
    case(state)
        IDLE: begin
            if (pattern == 4'b1101) begin
                next_state = SHIFT;
            end else begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            if (shift_count == 4'b1000) begin
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
        default: begin
            next_state = IDLE;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_count <= 4'b0000;
        pattern <= 4'b0000;
    end else begin
        state <= next_state;
        if (state == SHIFT) begin
            shift_count <= shift_count + 1'b1;
        end else begin
            shift_count <= 4'b0000;
        end
        if (state == IDLE) begin
            pattern <= {pattern[2:0], data};
        end else begin
            pattern <= pattern;
        end
    end
end

endmodule