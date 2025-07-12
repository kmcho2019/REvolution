module TopModule(
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
parameter IDLE = 4'd0;
parameter SHIFT = 4'd1;
parameter COUNT = 4'd2;
parameter DONE = 4'd3;

// Current state register
reg [3:0] state;
reg [3:0] next_state;

// Shift counter
reg [1:0] shift_count;
reg [1:0] next_shift_count;

// Pattern detector
reg [3:0] pattern;
reg [3:0] next_pattern;

// Output registers
reg shift_ena_reg;
reg counting_reg;
reg done_reg;

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_count <= 0;
        pattern <= 0;
        shift_ena_reg <= 0;
        counting_reg <= 0;
        done_reg <= 0;
    end else begin
        state <= next_state;
        shift_count <= next_shift_count;
        pattern <= next_pattern;
        shift_ena_reg <= (state == SHIFT) && (shift_count < 4);
        counting_reg <= (state == COUNT);
        done_reg <= (state == DONE);
    end
end

// Combinational logic
always @(*) begin
    next_state = state;
    next_shift_count = shift_count;
    next_pattern = {data, pattern[3:1]};
    
    case (state)
        IDLE: begin
            if (next_pattern == 4'd13) begin // 1101
                next_state = SHIFT;
            end
        end
        SHIFT: begin
            next_shift_count = shift_count + 1;
            if (shift_count == 3) begin
                next_state = COUNT;
            end
        end
        COUNT: begin
            if (done_counting) begin
                next_state = DONE;
            end
        end
        DONE: begin
            if (ack) begin
                next_state = IDLE;
            end
        end
    endcase
end

// Output assignments
assign shift_ena = shift_ena_reg;
assign counting = counting_reg;
assign done = done_reg;

endmodule