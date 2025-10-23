module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

// Parameters
parameter SEQUENCE_BITS = 4;
parameter DELAY_BITS = 4;
parameter COUNTER_BITS = 20;

// Registers
reg [SEQUENCE_BITS-1:0] seq_reg;
reg [DELAY_BITS-1:0] delay_reg;
reg [COUNTER_BITS-1:0] counter;
reg [DELAY_BITS-1:0] remaining_delay;

// Finite State Machine (FSM) states
enum {IDLE, COUNTING, DONE} state, next_state;

// Sequence detection and delay registration
always @(posedge clk or posedge reset) begin
    if (reset) begin
        seq_reg <= 0;
        delay_reg <= 0;
    end else if (state == IDLE) begin
        seq_reg <= {seq_reg[SEQUENCE_BITS-2:0], data};
        if (seq_reg == 4'b1101) begin
            seq_reg <= 0;
        end
    end else if (state == IDLE && seq_reg == 4'b1101) begin
        delay_reg <= {data, delay_reg[DELAY_BITS-1:1]};
        if (delay_reg[0] == 1'b1) begin
            delay_reg <= delay_reg;
        end
    end
end

// Counter implementation
always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0;
        remaining_delay <= 0;
    end else if (state == COUNTING) begin
        if (counter > 0) begin
            counter <= counter - 1;
            if (counter % 1000 == 0) begin
                remaining_delay <= remaining_delay - 1;
            end
        end
    end else if (state == IDLE && seq_reg == 4'b1101 && delay_reg[0] == 1'b1) begin
        counter <= (delay_reg + 1) * 1000 - 1;
        remaining_delay <= delay_reg;
    end
end

// FSM
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            if (seq_reg == 4'b1101 && delay_reg[0] == 1'b1) begin
                next_state = COUNTING;
            end else begin
                next_state = IDLE;
            end
        end
        COUNTING: begin
            if (counter == 0) begin
                next_state = DONE;
            end else begin
                next_state = COUNTING;
            end
        end
        DONE: begin
            if (ack == 1'b1) begin
                next_state = IDLE;
            end else begin
                next_state = DONE;
            end
        end
    endcase
end

// Output assignments
always @(*) begin
    counting = (state == COUNTING);
    done = (state == DONE);
    count = remaining_delay;
end

endmodule