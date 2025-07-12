module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

// States
enum logic [2:0] {
    Idle,
    Shift_in_delay,
    Counting,
    Done
} state, next_state;

// Registers
logic [3:0] delay;
logic [3:0] remaining_time;
logic [3:0] current_count;
logic [3:0] shift_reg;
logic [9:0] counter;

// State Machine Logic
always_comb begin
    next_state = state;
    case (state)
        Idle: begin
            if (shift_reg == 4'b1101) next_state = Shift_in_delay;
        end
        Shift_in_delay: begin
            if (counter == 10'd4) next_state = Counting;
        end
        Counting: begin
            if (remaining_time == 0) next_state = Done;
        end
        Done: begin
            if (ack) next_state = Idle;
        end
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        state <= Idle;
        shift_reg <= 0;
        counter <= 0;
        remaining_time <= 0;
        current_count <= 0;
        delay <= 0;
    end else begin
        state <= next_state;
        case (state)
            Idle: begin
                shift_reg <= {shift_reg[2:0], data};
            end
            Shift_in_delay: begin
                shift_reg <= {shift_reg[2:0], data};
                counter <= counter + 1;
                if (counter == 10'd4) delay <= {shift_reg[3:0]};
            end
            Counting: begin
                if (counter == 10'd1000) begin
                    counter <= 0;
                    remaining_time <= remaining_time - 1;
                    current_count <= current_count - 1;
                end else begin
                    counter <= counter + 1;
                end
            end
            Done: begin
                // do nothing
            end
        endcase
    end
end

// Output Logic
assign count = (state == Counting) ? current_count : 4'bxxxx;
assign counting = (state == Counting);
assign done = (state == Done);

// Initialize remaining_time and current_count
always_ff @(posedge clk) begin
    if (state == Shift_in_delay && counter == 10'd4) begin
        remaining_time <= delay;
        current_count <= delay;
    end
end

endmodule