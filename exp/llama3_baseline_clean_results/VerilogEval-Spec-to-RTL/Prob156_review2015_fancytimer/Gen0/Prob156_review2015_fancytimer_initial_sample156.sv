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
enum logic [2:0] {IDLE, SHIFT, COUNT, DONE} state, next_state;

// Registers
logic [3:0] delay;
logic [9:0] counter; // counter for 1000 cycles
logic [3:0] remaining_time;

// Shift register for pattern detection
logic [3:0] shift_reg;

// Pattern detection logic
always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 4'b0000;
    end else begin
        shift_reg <= {shift_reg[2:0], data};
    end
end

// Next state logic
always_comb begin
    case(state)
        IDLE: begin
            if (shift_reg == 4'b1101) begin
                next_state = SHIFT;
            end else begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            if (counter == 10'd4) begin
                next_state = COUNT;
            end else begin
                next_state = SHIFT;
            end
        end
        COUNT: begin
            if (counter == delay + 1) begin
                next_state = DONE;
            end else begin
                next_state = COUNT;
            end
        end
        DONE: begin
            if (ack) begin
                next_state = IDLE;
            end else begin
                next_state = DONE;
            end
        end
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

// Counter logic
always @(posedge clk) begin
    if (reset || (state == IDLE && ack)) begin
        counter <= 10'd0;
    end else if (state == SHIFT) begin
        counter <= counter + 1;
    end else if (state == COUNT) begin
        counter <= counter + 1;
    end
end

// Delay register
always @(posedge clk) begin
    if (state == SHIFT && counter == 10'd4) begin
        delay <= {data, shift_reg[3:1]};
    end
end

// Remaining time logic
always @(posedge clk) begin
    if (state == COUNT) begin
        if (counter % 10'd1000 == 10'd0) begin
            remaining_time <= remaining_time - 1;
        end
    end else if (state == IDLE) begin
        remaining_time <= 4'd0;
    end
end

// Output logic
assign count = (state == COUNT) ? remaining_time : 4'd0;
assign counting = (state == COUNT) ? 1'b1 : 1'b0;
assign done = (state == DONE) ? 1'b1 : 1'b0;

endmodule